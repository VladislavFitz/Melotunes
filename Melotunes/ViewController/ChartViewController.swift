import Foundation
import UIKit
import Combine

final class СhartViewController: UIViewController {
  
  private let viewModel: ChartViewModel
  private let artistsTableViewController: ArtistsTableViewController
  private var cancellables = Set<AnyCancellable>()
  
  init(viewModel: ChartViewModel) {
    self.artistsTableViewController = ArtistsTableViewController()
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    addChild(artistsTableViewController)
    artistsTableViewController.didMove(toParent: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupLayout()
    setupArtistsViewController()
    setupBindings()
  }
  
}

private extension СhartViewController {
  
  @objc func triggerRefresh() {
    viewModel.fetchChart()
  }
  
  private func setupArtistsViewController() {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(triggerRefresh), for: .valueChanged)
    artistsTableViewController.refreshControl = refreshControl
    artistsTableViewController.didSelect = { [weak viewModel] in
      viewModel?.selectArtist(atIndex: $0)
    }
  }
  
  private func setupBindings() {
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
  }
  
  private func setupLayout() {
    let artistsTableView = artistsTableViewController.view!
    artistsTableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(artistsTableView)
    artistsTableView.pin(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
  }
  
  private func updateState(_ state: ChartViewModel.State) {
    switch state {
    case .initial:
      artistsTableViewController.refreshControl?.endRefreshing()
      artistsTableViewController.viewModels.removeAll()
    case .displayChart(let chart):
      artistsTableViewController.refreshControl?.endRefreshing()
      artistsTableViewController.viewModels = chart.items.map(ArtistCellViewModel.init)
    case .loading:
      artistsTableViewController.refreshControl?.beginRefreshing()
    }
  }
  
}
