import Foundation

struct DeezerArtist: Decodable {
  let id: Int
  let name: String
  let nb_fan: Int?
  let nb_album: Int?
  let picture_xl: URL
}

extension Artist {
  
  init(_ artist: DeezerArtist) {
    self.init(id: artist.id,
              name: artist.name,
              imageURL: artist.picture_xl,
              fansCount: artist.nb_fan ?? 0,
              albumsCount: artist.nb_album ?? 0)
  }
  
}
