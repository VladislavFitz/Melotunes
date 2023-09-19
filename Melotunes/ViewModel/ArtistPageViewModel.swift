import Foundation
import Combine

final class ArtistPageViewModel {
  
  @Published
  var artist: Artist
  
  @Published
  var state: State
  
  var title: AnyPublisher<String?, Never>!
  var photoImageURL: AnyPublisher<URL?, Never>!

  let artistService: ArtistService
  let tracksService: TracksService
  
  var requestTrack: PassthroughSubject<(Int, [Track]), Never>
  var error: PassthroughSubject<Error, Never>
  
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
       artistService: ArtistService,
       tracksService: TracksService) {
    self.artist = artist
    self.artistService = artistService
    self.tracksService = tracksService
    self.state = .initial
    self.requestTrack = .init()
    self.error = .init()
    photoImageURL = $artist
      .map { $0.imageURL }
      .eraseToAnyPublisher()
    title = $artist
      .map { $0.name }
      .eraseToAnyPublisher()
  }
  
  func fetchData() {
    state = .loading
    Task {
      do {
        let tracks = try await tracksService.fetchTracks(for: artist)
        self.state = .displayTracks(tracks)
        let artist = try await artistService.fetchArtist(withID: artist.id)
        self.artist = artist
      } catch let error {
        self.error.send(error)
        self.state = .initial
      }
    }
  }
  
  func selectTrack(atIndex trackIndex: Int) {
    requestTrack.send((trackIndex, trackList))
  }
    
}
