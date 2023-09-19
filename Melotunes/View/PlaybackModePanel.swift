import Foundation
import UIKit

final class PlaybackModePanel: UIView {
  
  let shuffleButton: UIButton
  let repeatButton: UIButton
  
  enum Repeat {
    case off
    case on(single: Bool)
  }
  
  var isShuffleOn: Bool {
    didSet {
      shuffleButton.backgroundColor = isShuffleOn ? .systemBlue.withAlphaComponent(0.3) : .clear
    }
  }
  
  var repeatState: Repeat {
    didSet {
      switch repeatState {
      case .off:
        repeatButton.backgroundColor = .clear
        repeatButton.isSelected = false
      case .on(single: let isSingle):
        repeatButton.isSelected = isSingle
        repeatButton.backgroundColor = .systemBlue.withAlphaComponent(0.3)
      }
    }
  }
  
  override init(frame: CGRect) {
    self.shuffleButton = UIButton(autolayout: ())
    self.repeatButton = UIButton(autolayout: ())
    self.isShuffleOn = false
    self.repeatState = .off
    super.init(frame: frame)
    setupSubviews()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
}

private extension PlaybackModePanel {
  
  func setupSubviews() {
    shuffleButton.setImage(.shuffle, for: .normal)
    shuffleButton.imageEdgeInsets = UIEdgeInsets(top: 3,
                                                 left: 3,
                                                 bottom: 3,
                                                 right: 3)
    shuffleButton.contentEdgeInsets.right = 2
    shuffleButton.contentEdgeInsets.bottom = 2
    shuffleButton.layer.cornerRadius = 5
    shuffleButton.layer.masksToBounds = true
    repeatButton.setImage(.repeat, for: .normal)
    repeatButton.setImage(.repeatSingle, for: .selected)
    repeatButton.imageEdgeInsets = UIEdgeInsets(top: 3,
                                                left: 3,
                                                bottom: 3,
                                                right: 3)
    repeatButton.contentEdgeInsets.right = 2
    repeatButton.contentEdgeInsets.bottom = 2
    repeatButton.layer.cornerRadius = 5
    repeatButton.layer.masksToBounds = true
  }
  
  func setupLayout() {
    let stackView: UIStackView = .hStack(spacing: 30) {
      [
        .placeholder,
        shuffleButton,
        repeatButton,
        .placeholder,
      ]
    }
    addSubview(stackView)
    stackView.pin(to: self)
  }
  
}

private extension UIImage {
  
  static let shuffle = UIImage(systemName: "shuffle")!
  static let repeatSingle = UIImage(systemName: "repeat.1")!
  static let `repeat` = UIImage(systemName: "repeat")!
  
}
