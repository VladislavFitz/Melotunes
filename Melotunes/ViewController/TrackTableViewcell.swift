import Foundation
import UIKit

final class TrackTableViewcell: UITableViewCell {
  
  let albumCoverImageView: UIImageView
  let titleLabel: UILabel
  let albumTitleLabel: UILabel
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.albumCoverImageView = .init(autolayout: ())
    self.titleLabel = .init(autolayout: ())
    self.albumTitleLabel = .init(autolayout: ())
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
    setupAlbumTitleLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

private extension TrackTableViewcell {
  
  private func setupAlbumTitleLabel() {
    albumTitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
    albumTitleLabel.textColor = .systemGray2
  }
  
  func setupLayout() {
    albumCoverImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    let stackView = UIView.hStack(spacing: 10) {
      [
        albumCoverImageView,
        .vStack(spacing: 7) {
          [
            titleLabel,
            albumTitleLabel,
            .placeholder
          ]
        }
      ]
    }
    contentView.addSubview(stackView)
    stackView.pin(to: contentView, insets: UIEdgeInsets(top: 12, left: 12, bottom: -12, right: -12))
  }
  
}
