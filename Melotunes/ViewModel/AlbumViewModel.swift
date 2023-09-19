import Foundation
import Combine

final class AlbumViewModel {
  
  let descriptor: AlbumDescriptor
  let albumService: AlbumService
  
  var requestTrack: PassthroughSubject<(Int, [Track]), Never>
  var error: PassthroughSubject<Error, Never>
  
  @Published
  var state: State
  
  var coverImageURL: AnyPublisher<URL?, Never>!
  var artistName: AnyPublisher<String?, Never>!
  var releaseYear: AnyPublisher<String?, Never>!
    
  enum State {
    case initial
    case loading
    case displayAlbum(Album)
  }
  
  init(descriptor: AlbumDescriptor, albumService: AlbumService) {
    self.descriptor = descriptor
    self.albumService = albumService
    self.requestTrack = .init()
    self.error = .init()
    self.state = .initial
    self.coverImageURL = Just(descriptor.coverImageURL).eraseToAnyPublisher()
    self.artistName = $state
      .map { state in
        if case .displayAlbum(let album) = state {
          return album.artist.name
        } else {
          return nil
        }
      }
      .eraseToAnyPublisher()
    self.releaseYear = $state
      .map { state in
        if case .displayAlbum(let album) = state {
          let yearDateFormatter = DateFormatter()
          yearDateFormatter.dateFormat = "yyyy"
          return yearDateFormatter.string(from: album.releaseDate)
        } else {
          return nil
        }
      }
      .eraseToAnyPublisher()
  }
  
  func fetchData() {
    Task {
      do {
        let album = try await albumService.fetchAlbum(withID: descriptor.id)
        self.state = .displayAlbum(album)
      } catch let error {
        self.error.send(error)
        self.state = .initial
      }
    }
  }
  
  func selectTrack(atIndex index: Int) {
    if case .displayAlbum(let album) = state {
      requestTrack.send((index, album.tracks))
    }
  }
  
}
