import Foundation
import UIKit

class ViewControllerFactory {
  
  func chartViewController(with viewModel: ChartViewModel) -> UIViewController {
    СhartViewController(viewModel: viewModel)
  }
  
  func artistPageViewController(with viewModel: ArtistPageViewModel) -> UIViewController {
    ArtistPageViewController(viewModel: viewModel)
  }
  
  func albumViewController(with viewModel: AlbumViewModel) -> UIViewController {
    AlbumViewController(viewModel: viewModel)
  }
  
  func playerViewController(with viewModel: PlayerViewModel) -> UIViewController {
    PlayerViewController(viewModel: viewModel)
  }
  
  func errorViewController(for error: Error) -> UIViewController {
    let alertController = UIAlertController(title: "Error occured",
                                            message: error.localizedDescription,
                                            preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK",
                                            style: .cancel))
    return alertController
  }
  
}
