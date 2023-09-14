import Foundation

protocol TracksService {
    
  func fetchTracks(for artist: Artist) async throws -> [Track]
  
}
