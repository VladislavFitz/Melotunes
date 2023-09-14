import Foundation
import UIKit
import Combine

final class ArtistPageViewController: UIViewController {
  
  private let viewModel: ArtistPageViewModel
  
  private let pictureImageView: UIImageView
  private let tracksTableViewController: TracksTableViewController
  
  private var cancellables = Set<AnyCancellable>()
  
  init(viewModel: ArtistPageViewModel) {
    self.pictureImageView = .init()
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
    setupPhotoImageView()
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
      .sink { [weak pictureImageView] imageURL in
        pictureImageView?.sd_setImage(with: imageURL)
      }
      .store(in: &cancellables)
  }
  
  @objc func triggerRefresh() {
    viewModel.fetchTracks()
  }

  func setupTracksViewController() {
    let refreshControl = UIRefreshControl()
    tracksTableViewController.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(triggerRefresh), for: .valueChanged)
    tracksTableViewController.tableView.tableHeaderView = pictureImageView
    tracksTableViewController.didSelect = { [weak self] in
      self?.viewModel.select($0)
    }
  }
  
  func setupPhotoImageView() {
    pictureImageView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.width)
    pictureImageView.contentMode = .scaleAspectFit
    pictureImageView.clipsToBounds = true
  }
  
  func setupLayout() {
    let trackListView = tracksTableViewController.view!
    trackListView.translatesAutoresizingMaskIntoConstraints = false
    let stackView = UIStackView.vStack {
      [
        trackListView,
      ]
    }
    view.addSubview(stackView)
    stackView.pin(top: view.safeAreaLayoutGuide.topAnchor,
                  bottom: view.bottomAnchor,
                  leading: view.leadingAnchor,
                  trailing: view.trailingAnchor)
  }
  
}
