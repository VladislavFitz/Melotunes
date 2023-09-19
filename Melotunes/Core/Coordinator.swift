import Foundation
import UIKit
import Combine

final class Coordinator {
  
  let navigationController: UINavigationController
  let viewModelFactory: ViewModelFactory
  let viewControllerFactory: ViewControllerFactory
  
  private var cancellables: Set<AnyCancellable>
  
  init(navigationController: UINavigationController,
       viewModelFactory: ViewModelFactory,
       viewControllerFactory: ViewControllerFactory) {
    self.navigationController = navigationController
    self.viewModelFactory = viewModelFactory
    self.viewControllerFactory = viewControllerFactory
    self.cancellables = []
  }
  
  func presentMainViewController() {
    let viewModel = viewModelFactory.chartViewModel()
    viewModel.error
      .receive(on: DispatchQueue.main)
      .sink { [weak self] error in
        self?.presentError(error)
      }
      .store(in: &cancellables)
    viewModel.requestArtist
      .receive(on: DispatchQueue.main)
      .sink { [weak self] artist in
        self?.presentArtist(artist)
      }
      .store(in: &cancellables)
    let viewController = viewControllerFactory.chartViewController(with: viewModel)
    navigationController.pushViewController(viewController,
                                            animated: false)
    viewModel.fetchChart()
  }
  
  func presentArtist(_ artist: Artist, animated: Bool = true) {
    let viewModel = viewModelFactory.artistPageViewModel(for: artist)
    viewModel.error
      .receive(on: DispatchQueue.main)
      .sink { [weak self] error in
        self?.presentError(error)
      }
      .store(in: &cancellables)
    viewModel.requestTrack
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (index, list) in
        self?.presentTrack(atIndex: index,
                           from: list,
                           of: artist)
      }
      .store(in: &cancellables)
    let viewController = viewControllerFactory.artistPageViewController(with: viewModel)
    navigationController.pushViewController(viewController,
                                            animated: animated)
    viewModel.fetchData()
  }
  
  func presentAlbum(_ album: AlbumDescriptor, of artist: Artist, animated: Bool = true) {
    
    if (navigationController.topViewController as? AlbumViewController)?.viewModel.descriptor.id == album.id {
      navigationController.presentedViewController?.dismiss(animated: animated)
      return
    }
    
    let viewModel = viewModelFactory.albumViewModel(for: album)
    viewModel.requestTrack
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (index, list) in
        self?.presentTrack(atIndex: index,
                           from: list,
                           of: artist)
      }
      .store(in: &cancellables)
    
    let viewController = viewControllerFactory.albumViewController(with: viewModel)
    if navigationController.presentedViewController != nil {
      navigationController.presentedViewController?.dismiss(animated: animated) {
        self.navigationController.pushViewController(viewController, animated: true)
      }
    }
    viewModel.fetchData()
  }
  
  func presentTrack(atIndex trackIndex: Int,
                    from trackList: [Track],
                    of artist: Artist,
                    animated: Bool = true) {
    let viewModel = viewModelFactory.playerViewModel(artist: artist,
                                                     trackList: trackList,
                                                     trackIndex: trackIndex)
    viewModel.requestAlbum
      .sink { [weak self] album in
        self?.presentAlbum(album, of: artist)
      }
      .store(in: &cancellables)
    let viewController = viewControllerFactory.playerViewController(with: viewModel)
    navigationController.present(viewController,
                                 animated: animated)
    viewModel.playCurrentTrack()
  }
  
  func presentError(_ error: Error, animated: Bool = true) {
    let errorViewController = viewControllerFactory.errorViewController(for: error)
    navigationController.present(errorViewController,
                                 animated: animated)
  }
  
}
