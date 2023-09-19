import Foundation
import UIKit

final class PlaybackProgressPanel: UIView {
  
  let elapsedTimeLabel: UILabel
  let timeLeftLabel: UILabel
  let progressView: UIProgressView

  override init(frame: CGRect) {
    self.progressView = .init(autolayout: ())
    self.elapsedTimeLabel = .init(autolayout: ())
    self.timeLeftLabel = .init(autolayout: ())
    super.init(frame: frame)
    setupLayout()
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

private extension PlaybackProgressPanel {
  
  func setupSubviews() {
    progressView.transform = CGAffineTransformMakeScale(1, 2)
  }
  
  func setupLayout() {
    let stackView = UIStackView.vStack(spacing: 10) {
      [
        progressView,
        .hStack{
          [
            elapsedTimeLabel,
            .placeholder,
            timeLeftLabel,
          ]
        },
      ]
    }
    addSubview(stackView)
    stackView.pin(to: self)
  }
  
}
