import Foundation

struct DeezerAlbum: Decodable {
  let title: String
  let cover_xl: URL
  let release_date: String
  let artist: DeezerArtist
  let tracks: Tracks
  
  struct Tracks: Decodable {
    let data: [DeezerTrack]
  }
}

extension Album {
  
  init(_ deezerAlbum: DeezerAlbum) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    self.init(title: deezerAlbum.title,
              coverImageURL: deezerAlbum.cover_xl,
              releaseDate: dateFormatter.date(from:  deezerAlbum.release_date)!,
              artist: Artist(deezerAlbum.artist),
              tracks: deezerAlbum.tracks.data.map(Track.init))
  }
  
}
