import Foundation

final class DeezerMusicService: ChartService & TracksService & ArtistService & AlbumService {
  
  let baseURL: String
  let session: URLSession
  let jsonDecoder: JSONDecoder
  
  init(session: URLSession = .shared,
       jsonDecoder: JSONDecoder = .init()) {
    self.baseURL = "https://api.deezer.com"
    self.session = session
    self.jsonDecoder = jsonDecoder
  }
  
  func fetchChart() async throws -> Chart {
    let url = URL(string: baseURL + "/chart/0/artists")!
    let request = URLRequest(url: url)
    let (data, _) = try await session.data(for: request)
    return try jsonDecoder.decode(DeezerChart.self, from: data)
  }
  
  func fetchTracks(for artist: Artist) async throws -> [Track] {
    let url = URL(string: baseURL + "/artist/\(artist.id)/top")!
    var parameters = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    parameters.queryItems = [
      URLQueryItem(name: "limit", value: "50")
    ]
    let request = URLRequest(url: parameters.url!)
    let (data, _) = try await session.data(for: request)
    return try jsonDecoder.decode(DeezerTrackList.self, from: data).data
  }
  
  func fetchArtist(withID artistID: Int) async throws -> Artist {
    let url = URL(string: baseURL + "/artist/\(artistID)")!
    let request = URLRequest(url: url)
    let (data, _) = try await session.data(for: request)
    return try jsonDecoder.decode(DeezerArtist.self, from: data)
  }
  
  func fetchAlbum(withID albumID: Int) async throws -> Album {
    let url = URL(string: baseURL + "/album/\(albumID)")!
    let request = URLRequest(url: url)
    let (data, _) = try await session.data(for: request)
    let deezerAlbum = try jsonDecoder.decode(DeezerAlbum.self, from: data)
    let album = Album(deezerAlbum)
    return album
  }
  
}
