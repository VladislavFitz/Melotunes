import Foundation
import UIKit

final class PlaybackControlPanel: UIView {
  
  let backwardButton: UIButton
  let playPauseButton: UIButton
  let forwardButton: UIButton
  
  var isPlaying: Bool = false {
    didSet {
      playPauseButton.isSelected = isPlaying
    }
  }
  
  override init(frame: CGRect) {
    self.backwardButton = .init(autolayout: ())
    self.playPauseButton = .init(autolayout: ())
    self.forwardButton = .init(autolayout: ())
    super.init(frame: frame)
    setupSubviews()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

private extension PlaybackControlPanel {
 
  func setupSubviews() {
    backwardButton.setImage(.back, for: .normal)
    playPauseButton.setImage(.play, for: .normal)
    playPauseButton.setImage(.pause, for: .selected)
    forwardButton.setImage(.forward, for: .normal)
  }
  
  func setupLayout() {
    let stackView: UIStackView = .hStack(spacing: 50) {
      [
        .placeholder,
        backwardButton,
        playPauseButton,
        forwardButton,
        .placeholder,
      ]
    }
    addSubview(stackView)
    stackView.pin(to: self)
  }

}

private extension UIImage {
  
  private static func largeImage(systemName: String) -> UIImage {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
    return UIImage(systemName: systemName, withConfiguration: largeConfig)!
  }
  
  static let back = largeImage(systemName: "backward.fill")
  static let forward = largeImage(systemName: "forward.fill")
  static let play = largeImage(systemName: "play.fill")
  static let pause = largeImage(systemName: "pause.fill")
  
}
