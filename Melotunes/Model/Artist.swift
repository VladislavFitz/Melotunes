import Foundation

struct Artist {
  
  let id: Int
  let name: String
  let imageURL: URL
  let fansCount: Int
  let albumsCount: Int
  
  init(id: Int,
       name: String,
       imageURL: URL,
       fansCount: Int,
       albumsCount: Int) {
    self.id = id
    self.name = name
    self.imageURL = imageURL
    self.fansCount = fansCount
    self.albumsCount = albumsCount
  }
  
}
