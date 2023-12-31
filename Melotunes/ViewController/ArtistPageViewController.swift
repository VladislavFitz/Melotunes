import Foundation
import UIKit
import Combine

final class ArtistPageViewController: UIViewController {
  
  let viewModel: ArtistPageViewModel
  
  private let headerView: ArtistPageHeaderView
  private let tracksTableViewController: TracksTableViewController
  
  private var cancellables = Set<AnyCancellable>()
  
  init(viewModel: ArtistPageViewModel) {
    self.headerView = ArtistPageHeaderView(autolayout: ())
    self.tracksTableViewController = TracksTableViewController()
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    addChild(tracksTableViewController)
    tracksTableViewController.didMove(toParent: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupTracksViewController()
    setupBindings()
    setupLayout()
  }
  
}

private extension ArtistPageViewController {
  
  func updateState(_ state: ArtistPageViewModel.State) {
    switch state {
    case .initial:
      tracksTableViewController.tableView.refreshControl?.endRefreshing()
      tracksTableViewController.viewModels.removeAll()
    case .displayTracks(let tracks):
      tracksTableViewController.tableView.refreshControl?.endRefreshing()
      tracksTableViewController.viewModels = tracks.map(TrackCellViewModel.init)
    case .loading:
      tracksTableViewController.tableView.refreshControl?.beginRefreshing()
    }
  }
  
  func setupBindings() {
    viewModel.title
      .receive(on: DispatchQueue.main)
      .sink { [weak self] title in
        self?.title = title
      }
      .store(in: &cancellables)
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.updateState(state)
      }
      .store(in: &cancellables)
    viewModel.photoImageURL
      .receive(on: DispatchQueue.main)
      .sink { [weak headerView] imageURL in
        headerView?.imageView.sd_setImage(with: imageURL)
      }
      .store(in: &cancellables)
    viewModel.$artist
      .receive(on: DispatchQueue.main)
      .sink { [weak headerView] artist in
        headerView?.albumsCountLabel.text = "Albums: \(artist.albumsCount)"
        headerView?.fansCountLabel.text = "Fans: \(artist.fansCount)"
      }
      .store(in: &cancellables)
  }
  
  @objc func triggerRefresh() {
    viewModel.fetchData()
  }
  
  func setupTracksViewController() {
    let refreshControl = UIRefreshControl()
    tracksTableViewController.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(triggerRefresh), for: .valueChanged)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    tracksTableViewController.tableView.tableHeaderView = headerView
    headerView.widthAnchor.constraint(equalTo: tracksTableViewController.view.widthAnchor).isActive = true
    tracksTableViewController.selectTrackAtIndex
      .sink { [weak self] trackIndex in
        self?.viewModel.selectTrack(atIndex: trackIndex)
      }
      .store(in: &cancellables)
  }
  
  func setupLayout() {
    let trackListView = tracksTableViewController.view!
    trackListView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(trackListView)
    trackListView.pin(top: view.safeAreaLayoutGuide.topAnchor,
                      bottom: view.bottomAnchor,
                      leading: view.leadingAnchor,
                      trailing: view.trailingAnchor)
  }
  
}
