import Foundation

final class DeezerMusicService: ChartService & TracksService {
  
  let baseURL: URL
  let session: URLSession
  let jsonDecoder: JSONDecoder
  
  init(session: URLSession = .shared,
       jsonDecoder: JSONDecoder = .init()) {
    self.baseURL = URL(string: "https://api.deezer.com")!
    self.session = session
    self.jsonDecoder = jsonDecoder
  }
  
  func fetchChart() async throws -> Chart {
    let url = baseURL.appending(path: "/chart/0/artists")
    let request = URLRequest(url: url)
    let (data, _) = try await session.data(for: request)
    return try jsonDecoder.decode(DeezerChart.self, from: data)
  }
  
  func fetchTracks(for artist: Artist) async throws -> [Track] {
    let artistID = (artist as! DeezerArtist).id
    var parameters = URLComponents(url: baseURL.appending(path: "/artist/\(artistID)/top"), resolvingAgainstBaseURL: true)!
    parameters.queryItems = [
      URLQueryItem(name: "limit", value: "50")
    ]
    let request = URLRequest(url: parameters.url!)
    let (data, _) = try await session.data(for: request)
    return try jsonDecoder.decode(DeezerTrackList.self, from: data).data
  }
  
}
