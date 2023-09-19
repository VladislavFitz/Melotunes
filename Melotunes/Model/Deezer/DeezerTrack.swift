import Foundation

struct DeezerTrack: Decodable {
  let title: String
  let album: DeezerAlbumDescriptor
  let preview: URL
  let duration: TimeInterval
}

extension Track {
  
  init(_ track: DeezerTrack) {
    self.init(title: track.title,
              sourceAlbum: AlbumDescriptor(track.album),
              duration: track.duration,
              previewURL: track.preview)
  }
  
}
