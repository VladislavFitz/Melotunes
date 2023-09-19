import Foundation

protocol AlbumDescriptor {
  
  var id: Int { get }
  var title: String { get }
  var coverImageURL: URL { get }
  
}
