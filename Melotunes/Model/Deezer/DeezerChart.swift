import Foundation

struct DeezerChart: Chart, Decodable {
  
  var items: [Artist] {
    data
  }
  
  let data: [DeezerArtist]
  let total: Int
  
}
