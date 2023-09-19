import Foundation

struct Album {
  
  let title: String
  let coverImageURL: URL
  let releaseDate: Date
  let artist: Artist
  let tracks: [Track]
  
  init(title: String,
       coverImageURL: URL,
       releaseDate: Date,
       artist: Artist,
       tracks: [Track]) {
    self.title = title
    self.coverImageURL = coverImageURL
    self.releaseDate = releaseDate
    self.artist = artist
    self.tracks = tracks
  }
  
}
