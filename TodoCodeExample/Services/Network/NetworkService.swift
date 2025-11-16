import Foundation

protocol NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoAPIItem], NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private let urlString = "https://dummyjson.com/todos"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchTodos(completion: @escaping (Result<[TodoAPIItem], NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(TodoAPIResponse.self, from: data)
                completion(.success(apiResponse.todos))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}
