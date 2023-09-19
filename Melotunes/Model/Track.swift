import Foundation

struct Track {
  
  let title: String
  let album: AlbumDescriptor
  let duration: TimeInterval
  let previewURL: URL
  
  init(title: String,
       sourceAlbum: AlbumDescriptor,
       duration: TimeInterval,
       previewURL: URL) {
    self.title = title
    self.album = sourceAlbum
    self.duration = duration
    self.previewURL = previewURL
  }
  
}
