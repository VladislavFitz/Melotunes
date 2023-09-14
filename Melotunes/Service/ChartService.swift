import Foundation

protocol ChartService {
    
  func fetchChart() async throws -> Chart
  
}
