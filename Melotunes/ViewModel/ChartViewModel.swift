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
  
  var requestArtist: PassthroughSubject<Artist, Never>
  var error: PassthroughSubject<Error, Never>

  private let service: ChartService
  
  init(service: ChartService) {
    self.state = .initial
    self.service = service
    self.requestArtist = .init()
    self.error = .init()
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
        self.error.send(error)
        self.state = .initial
      }
    }
  }
  
  func selectArtist(atIndex index: Int) {
    if case .displayChart(let chart) = state {
      requestArtist.send(chart.items[index])
    }
  }
  
}
