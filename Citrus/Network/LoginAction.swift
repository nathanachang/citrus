import Foundation

struct LoginAction {
    enum LoginError: Error {
        case invalidURL
        case encodingError
        case networkError(Error)
        case decodingError
        case serverError(Int)
        case unknownError
    }
    
    var parameters: LoginRequest
    
    func call(completion: @escaping (Result<LoginResponse, LoginError>) -> Void) {
        let scheme: String = "https"
        let host: String = "beb982c7-544e-425f-975b-4375455b373c.mock.pstmn.io"
        let path = "/login"
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("true", forHTTPHeaderField: "x-mock-match-request-body")
        
        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            completion(.failure(.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
