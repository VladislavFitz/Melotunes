import Foundation
import Combine

final class ArtistPageViewModel {
  
  @Published
  var state: State
  
  var title: AnyPublisher<String?, Never>!
  var photoImageURL: AnyPublisher<URL?, Never>!

  let artist: Artist
  let service: TracksService
  
  var didRequestTrack: ((Int, [Track]) -> Void)?
  var didReceiveError: ((Error) -> Void)?

  enum State {
    case initial
    case loading
    case displayTracks([Track])
  }
  
  var trackList: [Track] {
    if case .displayTracks(let tracks) = state {
      return tracks
    }
    return []
  }
  
  init(artist: Artist,
       service: TracksService) {
    self.artist = artist
    self.service = service
    self.state = .initial
    photoImageURL = Just(artist.imageURL)
      .eraseToAnyPublisher()
    title = Just(artist.name)
      .eraseToAnyPublisher()
  }
  
  func fetchTracks() {
    state = .loading
    Task {
      do {
        let tracks = try await service.fetchTracks(for: artist)
        self.state = .displayTracks(tracks)
      } catch let error {
        self.didReceiveError?(error)
        self.state = .initial
      }
    }
  }
  
  func select(_ trackIndex: Int) {
    didRequestTrack?(trackIndex, trackList)
  }
  
}
