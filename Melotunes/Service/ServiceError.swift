import Foundation

enum ServiceError: Error {
  case networkError(Error)
  case httpError(Int)
  case decodingError(Error)
}
