import Foundation

struct ArtistCellViewModel {
  
  let name: String
  let photoImageURL: URL
  
  init(name: String, photoImageURL: URL) {
    self.name = name
    self.photoImageURL = photoImageURL
  }
  
}

extension ArtistCellViewModel {
  
  init(artist: Artist) {
    self.init(name: artist.name,
              photoImageURL: artist.imageURL)
  }
  
}
