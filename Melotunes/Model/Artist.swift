import Foundation

protocol Artist {
  
  var id: Int { get }
  var name: String { get }
  var imageURL: URL { get }
  var fansCount: Int { get }
  var albumsCount: Int { get }
  
}
