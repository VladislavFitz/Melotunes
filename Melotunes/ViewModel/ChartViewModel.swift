import Foundation
import Combine

final class ChartViewModel {
  
  enum State {
    case initial
    case loading
    case displayChart(Chart)
  }
  
  @Published
  var state: State
  
  var title: AnyPublisher<String?, Never>!
  
  var didRequestArtistPage: ((Artist) -> Void)?
  var didReceiveError: ((Error) -> Void)?
  
  private let service: ChartService
  
  init(service: ChartService) {
    self.state = .initial
    self.service = service
    title = Just("Top Artists")
      .eraseToAnyPublisher()
  }
  
  func fetchChart() {
    state = .loading
    Task {
      do {
        let chart = try await service.fetchChart()
        self.state = .displayChart(chart)
      } catch let error {
        self.didReceiveError?(error)
        self.state = .initial
      }
    }
  }
  
  func selectArtist(atIndex index: Int) {
    if case .displayChart(let chart) = state {
      didRequestArtistPage?(chart.items[index])
    }
  }
  
}
