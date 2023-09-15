import Foundation

protocol ArtistService {
    
  func fetchArtist(withID id: Int) async throws -> Artist
  
}
