import Foundation
@testable import TodoCodeExample

final class MockNetworkService: NetworkServiceProtocol {

    var mockResult: Result<[TodoAPIItem], NetworkError>?

    func fetchTodos(completion: @escaping (Result<[TodoAPIItem], NetworkError>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}
