import Foundation
import UIKit

final class ArtistTableViewCell: UITableViewCell {
  
  let artistPhotoImageView: UIImageView
  let nameLabel: UILabel

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.artistPhotoImageView = .init(autolayout: ())
    self.nameLabel = .init(autolayout: ())
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
    setupNameLabel()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

private extension ArtistTableViewCell {
  
  private func setupNameLabel() {
    nameLabel.font = .systemFont(ofSize: 24, weight: .medium)
  }
  
  private func setupLayout() {
    artistPhotoImageView.widthAnchor.constraint(equalToConstant: 86).isActive = true
    let stackView = UIView.hStack(spacing: 10) {
      [
        artistPhotoImageView,
        .vStack(spacing: 7) {
          [
            nameLabel,
            .placeholder
          ]
        }
      ]
    }
    contentView.addSubview(stackView)
    stackView.pin(to: contentView, insets: UIEdgeInsets(top: 12, left: 12, bottom: -12, right: -12))
  }
  
}
