import Foundation

struct TrackCellViewModel {
  
  let title: String
  let albumTitle: String
  let albumCoverURL: URL
    
  init(albumCoverURL: URL,
       title: String,
       albumTitle: String) {
    self.albumCoverURL = albumCoverURL
    self.title = title
    self.albumTitle = albumTitle
  }
  
}

extension TrackCellViewModel {
  
  init(track: Track) {
    self.init(albumCoverURL: track.album.coverImageURL,
              title: track.title,
              albumTitle: track.album.title)
  }
  
}
