import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  var coordinator: Coordinator!
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    let navigationController = UINavigationController()
    navigationController.navigationBar.prefersLargeTitles = true
    let viewModelFactory = ViewModelFactory(playerController: PlayerController(),
                                            musicService: DeezerMusicService())
    let viewControllerFactory = ViewControllerFactory()
    coordinator = Coordinator(navigationController: navigationController,
                              viewModelFactory: viewModelFactory,
                              viewControllerFactory: viewControllerFactory)
    window.rootViewController = navigationController
    self.window = window
    window.makeKeyAndVisible()
    coordinator.presentMainViewController()
  }
  
}

