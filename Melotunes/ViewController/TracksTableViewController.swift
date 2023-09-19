import Foundation
import UIKit
import Combine

final class TracksTableViewController: UITableViewController {
  
  var viewModels: [TrackCellViewModel] {
    didSet {
      tableView.reloadData()
    }
  }
  
  let selectTrackAtIndex: PassthroughSubject<Int, Never>
  
  private let cellID = "cellID"
  
  init() {
    viewModels = []
    selectTrackAtIndex = PassthroughSubject()
    super.init(style: .plain)
    tableView.register(TrackTableViewcell.self, forCellReuseIdentifier: cellID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModels.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectTrackAtIndex.send(indexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? TrackTableViewcell else {
      fatalError("TrackTableViewcell is not registered for identifier \(cellID)")
    }
    let viewModel = viewModels[indexPath.row]
    cell.albumCoverImageView.sd_setImage(with: viewModel.albumCoverURL)
    cell.titleLabel.text = viewModel.title
    cell.albumTitleLabel.text = viewModel.albumTitle
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    74
  }

}
