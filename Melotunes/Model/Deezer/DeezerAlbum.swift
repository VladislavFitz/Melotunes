import Foundation

struct DeezerAlbum: Album, Decodable {
  
  let id: Int
  let title: String
  let cover_xl: URL
  
  var coverImageURL: URL {
    cover_xl
  }
   
}
