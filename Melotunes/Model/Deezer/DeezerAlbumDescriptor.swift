import Foundation

struct DeezerAlbumDescriptor: Decodable {
  let id: Int
  let title: String
  let cover_xl: URL
}

extension AlbumDescriptor {
  
  init(_ descriptor: DeezerAlbumDescriptor) {
    self.init(id: descriptor.id,
              title: descriptor.title,
              coverImageURL: descriptor.cover_xl)
  }
  
}
