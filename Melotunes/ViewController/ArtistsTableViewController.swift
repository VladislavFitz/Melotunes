import Foundation
import UIKit

final class ArtistsTableViewController: UITableViewController {
  
  var viewModels: [ArtistCellViewModel] {
    didSet {
      tableView.reloadData()
    }
  }
  
  var didSelect: ((Int) -> Void)?
  
  private let cellID = "cellID"
  
  init() {
    viewModels = []
    super.init(style: .plain)
    tableView.register(ArtistTableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModels.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    didSelect?(indexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ArtistTableViewCell else {
      fatalError("\(ArtistTableViewCell.self) not registered for \(cellID)")
    }
    let viewModel = viewModels[indexPath.row]
    cell.artistPhotoImageView.sd_setImage(with: viewModel.photoImageURL)
    cell.nameLabel.text = viewModel.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    100
  }
  
}
