import Foundation

protocol Track {
  
  var title: String { get }
  var sourceAlbum: AlbumDescriptor { get }
  var duration: TimeInterval { get }
  var previewURL: URL { get }
  
}
