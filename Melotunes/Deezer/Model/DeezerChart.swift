import Foundation

struct DeezerChart: Decodable {
  let data: [DeezerArtist]
  let total: Int
}

extension Chart {
  
  init(_ chart: DeezerChart) {
    self.init(items: chart.data.map(Artist.init))
  }
  
}
