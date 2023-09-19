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
  
  private func checkResponse(_ response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
      return
    }
    guard (200..<300).contains(httpResponse.statusCode) else {
      throw ServiceError.httpError(httpResponse.statusCode)
    }
  }
  
  private func decode<T: Decodable>(_ data: Data) throws -> T {
    do {
      return try jsonDecoder.decode(T.self, from: data)
    } catch let error {
      throw ServiceError.decodingError(error)
    }
  }
  
  private func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
    do {
      return try await session.data(for: request)
    } catch let error {
      throw ServiceError.networkError(error)
    }
  }
  
  private func fetch<T: Decodable>(from path: String) async throws -> T {
    let url = URL(string: baseURL + path)!
    let request = URLRequest(url: url)
    let (data, response) = try await perform(request)
    try checkResponse(response)
    return try decode(data)
  }
  
  func fetchChart() async throws -> Chart {
    let deezerChart: DeezerChart = try await fetch(from: "/chart/0/artists")
    return Chart(deezerChart)
  }
  
  func fetchTracks(for artist: Artist) async throws -> [Track] {
    let url = URL(string: baseURL + "/artist/\(artist.id)/top")!
    var parameters = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    parameters.queryItems = [
      URLQueryItem(name: "limit", value: "50")
    ]
    let request = URLRequest(url: parameters.url!)
    let (data, response) = try await perform(request)
    try checkResponse(response)
    let deezerTrackList: DeezerTrackList = try decode(data)
    return deezerTrackList.data.map(Track.init)
  }
  
  func fetchArtist(withID artistID: Int) async throws -> Artist {
    let deezerArtist: DeezerArtist = try await fetch(from: "/artist/\(artistID)")
    return Artist(deezerArtist)
  }
  
  func fetchAlbum(withID albumID: Int) async throws -> Album {
    let deezerAlbum: DeezerAlbum = try await fetch(from: "/album/\(albumID)")
    return Album(deezerAlbum)
  }
  
}
