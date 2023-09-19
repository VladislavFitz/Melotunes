import Foundation
import UIKit

final class ArtistPageHeaderView: UIView {
  
  let imageView: UIImageView
  let albumsCountLabel: UILabel
  let fansCountLabel: UILabel
  let albumsIconImageView: UIImageView
  let fansIconImageView: UIImageView
  
  override init(frame: CGRect) {
    self.imageView = UIImageView(autolayout: ())
    self.albumsCountLabel = UILabel(autolayout: ())
    self.fansCountLabel = UILabel(autolayout: ())
    self.albumsIconImageView = UIImageView(autolayout: ())
    self.fansIconImageView = UIImageView(autolayout: ())
    super.init(frame: frame)
    setupSubviews()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

private extension ArtistPageHeaderView {
  
  private func setupSubviews() {
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    albumsIconImageView.image = UIImage(systemName: "square.stack")
    fansIconImageView.image = UIImage(systemName: "person.3.sequence")
    albumsCountLabel.font = .systemFont(ofSize: 14, weight: .light)
    fansCountLabel.font = .systemFont(ofSize: 14, weight: .light)
  }
  
  private func setupLayout() {
    let stackView: UIStackView = .vStack(spacing: 10) {
      [
        imageView,
        .hStack(distribution: .equalCentering, spacing: 5) {
          [
            .placeholder,
            .hStack(spacing: 4) {
              [
                albumsIconImageView,
                albumsCountLabel,
              ]
            },
            .placeholder,
            .hStack(spacing: 4) {
              [
                fansIconImageView,
                fansCountLabel,
              ]
            },
            .placeholder,
          ]
        },
      ]
    }
    addSubview(stackView)
    stackView.pin(to: self, insets: UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0))
    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
  }
  
}
