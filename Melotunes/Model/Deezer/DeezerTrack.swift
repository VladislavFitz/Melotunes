import Foundation

struct DeezerTrack: Track, Decodable {
  
  let title: String
  
  var sourceAlbum: Album {
    album
  }
  let album: DeezerAlbum
  
  var previewURL: URL {
    preview
  }
  let preview: URL
  
  var duration: TimeInterval
  
  init(title: String,
       album: DeezerAlbum,
       duration: TimeInterval,
       preview: URL) {
    self.title = title
    self.album = album
    self.duration = duration
    self.preview = preview
  }
  
}
