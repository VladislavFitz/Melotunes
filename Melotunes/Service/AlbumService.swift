import Foundation

protocol AlbumService {
  
  func fetchAlbum(withID id: Int) async throws -> Album
  
}
