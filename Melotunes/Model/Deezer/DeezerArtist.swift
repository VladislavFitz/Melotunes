import Foundation

struct DeezerArtist: Decodable, Artist {
  
  let id: Int
  let name: String
  
  var imageURL: URL {
    picture_xl
  }
  let picture_xl: URL
  
  init(id: Int, name: String, imageURL: URL) {
    self.id = id
    self.name = name
    self.picture_xl = imageURL
  }
  
}
