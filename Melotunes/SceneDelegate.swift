import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  var coordinator: MelotunesCoordinator!

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    let navigationController = UINavigationController()
    navigationController.navigationBar.prefersLargeTitles = true
    let viewModelFactory = ViewModelFactory(playerController: PlayerController(),
                                            musicService: DeezerMusicService())
    coordinator = MelotunesCoordinator(navigationController: navigationController,
                                       viewModelFactory: viewModelFactory)
    window.rootViewController = navigationController
    self.window = window
    window.makeKeyAndVisible()
    coordinator.presentMainViewController()
  }

}

