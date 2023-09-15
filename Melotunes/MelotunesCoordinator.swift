import Foundation
import UIKit

final class MelotunesCoordinator {
  
  let navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func presentMainViewController() {
    let service = DeezerMusicService()
    let viewModel = ChartViewModel(service: service)
    viewModel.didReceiveError = { [weak self] error in
      DispatchQueue.main.async {
        self?.presentError(error)
      }
    }
    viewModel.didRequestArtistPage = { [weak self] artist in
      DispatchQueue.main.async {
        self?.presentArtist(artist)
      }
    }
    let viewController = СhartViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController,
                                            animated: false)
    viewModel.fetchChart()
  }
  
  func presentArtist(_ artist: Artist, animated: Bool = true) {
    let service = DeezerMusicService()
    let viewModel = ArtistPageViewModel(artist: artist,
                                        artistService: service,
                                        tracksService: service)
    viewModel.didReceiveError = { [weak self] error in
      DispatchQueue.main.async {
        self?.presentError(error)
      }
    }
    viewModel.didRequestTrack = { [weak self] trackIndex, trackList in
      DispatchQueue.main.async {
        self?.presentTrack(atIndex: trackIndex, from: trackList, of: artist)
      }
    }
    let viewController = ArtistPageViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController,
                                            animated: animated)
    viewModel.fetchData()
  }
  
  func presentTrack(atIndex trackIndex: Int,
                    from trackList: [Track],
                    of artist: Artist,
                    animated: Bool = true) {
    let viewModel = PlayerViewModel(artist: artist,
                                    tracks: trackList,
                                    currentTrackIndex: trackIndex)
    let viewController = PlayerViewController(viewModel: viewModel)
    navigationController.present(viewController,
                                 animated: animated)
    viewModel.perform(.playPause)
  }
  
  func presentError(_ error: Error, animated: Bool = true) {
    let alertController = UIAlertController(title: "Error occured",
                                            message: error.localizedDescription,
                                            preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK",
                                            style: .cancel))
    navigationController.present(alertController,
                                 animated: animated)
  }
  
}
