import Foundation

struct DeezerTrack: Track, Decodable {
  
  let title: String
  
  var sourceAlbum: AlbumDescriptor {
    album
  }
  let album: DeezerAlbumDescriptor
  
  var previewURL: URL {
    preview
  }
  let preview: URL
  
  var duration: TimeInterval
  
  init(title: String,
       album: DeezerAlbumDescriptor,
       duration: TimeInterval,
       preview: URL) {
    self.title = title
    self.album = album
    self.duration = duration
    self.preview = preview
  }
  
}
