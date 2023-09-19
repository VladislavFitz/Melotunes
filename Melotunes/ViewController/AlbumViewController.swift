import Foundation
import UIKit
import Combine

final class AlbumViewController: UIViewController {
  
  let viewModel: AlbumViewModel
  
  private let headerView: AlbumHeaderView
  private let tracksTableViewController: TracksTableViewController
  
  private var cancellables = Set<AnyCancellable>()
  
  init(viewModel: AlbumViewModel) {
    self.viewModel = viewModel
    self.tracksTableViewController = TracksTableViewController()
    self.headerView = .init(frame: .zero)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupBindings()
    setupLayout()
    setupSubviews()
    setupTracksViewController()
  }
  
}

private extension AlbumViewController {
  
  @objc func triggerRefresh() {
    viewModel.fetchData()
  }
  
  func updateState(_ state: AlbumViewModel.State) {
    switch state {
    case .initial:
      tracksTableViewController.tableView.refreshControl?.endRefreshing()
      tracksTableViewController.viewModels.removeAll()
    case .displayAlbum(let album):
      tracksTableViewController.tableView.refreshControl?.endRefreshing()
      tracksTableViewController.viewModels = album.tracks.map(TrackCellViewModel.init)
    case .loading:
      tracksTableViewController.tableView.refreshControl?.beginRefreshing()
    }
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
  
  
  func setupSubviews() {
    headerView.imageView.sd_setImage(with: viewModel.descriptor.coverImageURL)
    headerView.yearLabel.text = viewModel.descriptor.title
  }
  
  func setupBindings() {
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.updateState(state)
      }
      .store(in: &cancellables)
    
    viewModel.coverImageURL
      .receive(on: DispatchQueue.main)
      .sink { [weak headerView] imageURL in
        headerView?.imageView.sd_setImage(with: imageURL)
      }
      .store(in: &cancellables)
    
    viewModel.artistName
      .receive(on: DispatchQueue.main)
      .sink { [weak headerView] artistName in
        headerView?.artistLabel.text = artistName
      }
      .store(in: &cancellables)
    
    viewModel.releaseYear
      .receive(on: DispatchQueue.main)
      .sink { [weak headerView] releaseYear in
        headerView?.yearLabel.text = releaseYear
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
