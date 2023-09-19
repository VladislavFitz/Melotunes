import Foundation

struct DeezerTrackList: Decodable {
  let data: [DeezerTrack]
  let total: Int
}
