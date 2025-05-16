import Foundation

enum NetworkClientMethdor: String {
    case GET
    case POST
}

protocol NetworkClientProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

protocol WebServiceProtocol {
    
    func execute<T: Decodable >(urlSring: String,
                                headers: Dictionary<String, String>?,
                                body: Dictionary<String, String>?,
                                methdor: NetworkClientMethdor,
                                completion: @escaping (Result<T, Error>) ->Void)
    func execute<T: Decodable>(
        urlSring: String,
        headers: [String: String]?,
        body: [String: String]?,
        method: NetworkClientMethdor
    ) async throws -> T
}

extension URLSession: NetworkClientProtocol {}

extension WebServiceProtocol {
    
    func execute<T: Decodable>(
        urlSring: String,
        headers: [String: String]? = nil,
        body: [String: String]? = nil,
        methdor: NetworkClientMethdor = .GET,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        execute(urlSring: urlSring, headers: headers, body: body, methdor: methdor, completion: completion)
    }
    
    func execute<T: Decodable>(
            urlSring: String,
            headers: [String: String]? = nil,
            body: [String: String]? = nil
        ) async throws -> T {
            try await execute(urlSring: urlSring, headers: headers, body: body, method: .GET)
    }
}

class WebService: WebServiceProtocol {
    
    let netWorkClient: NetworkClientProtocol
    
    init(netWorkClient: NetworkClientProtocol = URLSession.shared) {
        self.netWorkClient = netWorkClient
    }
    
    func execute<T>(
        urlSring: String,
        headers: [String: String]?,
        body: [String: String]?,
        methdor: NetworkClientMethdor,
        completion: @escaping (Result<T, Error>) -> Void
        
    ) where T: Decodable {
        do {
            
            let request = try makeRequest(urlSring: urlSring, headers: headers, body: body, method: methdor)
            
            netWorkClient.dataTask(with: request) { data, response, error in
                if let error = error as? ErrorCase {
                    completion(.failure(error))
                    return
                }
                
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let data else {
                    completion(.failure(ErrorCase.invalidResponse))
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch let error {
                    completion(.failure(ErrorCase.networkError(error)))
                }
            }.resume()
            
        } catch  {
            completion(.failure(error))
        }
    }
    
    func execute<T: Decodable>(
        urlSring: String,
        headers: [String: String]? = nil,
        body: [String: String]? = nil,
        method: NetworkClientMethdor = .GET
    ) async throws -> T {
        
        let request = try makeRequest(urlSring: urlSring, headers: headers, body: body, method: method)

        let (data, response) = try await netWorkClient.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200
        else {
            throw ErrorCase.invalidResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func makeRequest(
        urlSring: String,
        headers: [String: String]? = nil,
        body: [String: String]? = nil,
        method: NetworkClientMethdor = .GET
        
    ) throws -> URLRequest {
        
        guard let url = URL(string: urlSring) else {
            throw ErrorCase.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        if method == .POST && (headers?["Content-Type"] == nil) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if let body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }

        return request
    }
}
