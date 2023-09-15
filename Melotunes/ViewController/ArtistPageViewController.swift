import Foundation
import UIKit
import Combine

final class ArtistPageViewController: UIViewController {
  
  private let viewModel: ArtistPageViewModel
  
  private let photoImageView: UIImageView
  private let infoLabel: UILabel
  private let tracksTableViewController: TracksTableViewController
  
  private var cancellables = Set<AnyCancellable>()
  
  init(viewModel: ArtistPageViewModel) {
    self.photoImageView = .init()
    self.infoLabel = UILabel()
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
    setupInfoLabel()
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
      .sink { [weak photoImageView] imageURL in
        photoImageView?.sd_setImage(with: imageURL)
      }
      .store(in: &cancellables)
    viewModel.info
      .receive(on: DispatchQueue.main)
      .assign(to: \.text, on: infoLabel)
      .store(in: &cancellables)
  }
  
  @objc func triggerRefresh() {
    viewModel.fetchData()
  }

  func setupTracksViewController() {
    let refreshControl = UIRefreshControl()
    tracksTableViewController.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(triggerRefresh), for: .valueChanged)
    let headerView = UIView()
    headerView.frame = CGRect(x: 0,
                              y: 0,
                              width: UIScreen.main.bounds.width,
                              height: UIScreen.main.bounds.width + 20)
    headerView.addSubview(photoImageView)
    headerView.addSubview(infoLabel)
    photoImageView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.width)
    infoLabel.frame = CGRect(x: 0,
                             y: UIScreen.main.bounds.width + 4,
                             width: UIScreen.main.bounds.width,
                             height: 12)
    tracksTableViewController.tableView.tableHeaderView = headerView
    tracksTableViewController.didSelect = { [weak self] in
      self?.viewModel.selectTrack(atIndex: $0)
    }
  }
  
  func setupInfoLabel() {
    infoLabel.textAlignment = .center
    infoLabel.font = .systemFont(ofSize: 14, weight: .light)
  }
  
  func setupPhotoImageView() {
    photoImageView.contentMode = .scaleAspectFit
    photoImageView.clipsToBounds = true
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
