import Foundation

struct DeezerArtist: Decodable, Artist {
  
  let id: Int
  let name: String
  
  var fansCount: Int {
    nb_fan ?? 0
  }
  let nb_fan: Int?
  
  var imageURL: URL {
    picture_xl
  }
  let picture_xl: URL
  
}
