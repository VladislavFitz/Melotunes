import Foundation
import UIKit

final class AlbumHeaderView: UIView {
  
  let imageView: UIImageView
  let artistLabel: UILabel
  let yearLabel: UILabel
  let infoLabel: UILabel
  
  override init(frame: CGRect) {
    self.imageView = .init(autolayout: ())
    self.yearLabel = .init(autolayout: ())
    self.artistLabel = .init(autolayout: ())
    self.infoLabel = .init(autolayout: ())
    super.init(frame: frame)
    setupLayout()
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    artistLabel.font = .systemFont(ofSize: 20, weight: .bold)
    yearLabel.font = .systemFont(ofSize: 14, weight: .light)
  }
  
  private func setupLayout() {
    let stackView: UIView = .vStack(alignment: .center, spacing: 10) {
      [
        imageView,
        artistLabel,
        yearLabel,
        infoLabel,
      ]
    }
    addSubview(stackView)
    stackView.pin(to: self, insets: UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0))
    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
  }
  
}
