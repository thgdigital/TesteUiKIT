//
//  WebService.swift
//  TesteUiKIT
//
//  Created by Thiago Santos on 14/05/25.
//


class WebService: WebServiceProtocol {
    let netWorkClient: NetworkClientProtocol
    
    init(netWorkClient: NetworkClientProtocol = URLSession.shared) {
        self.netWorkClient = netWorkClient
    }
    
    
    func execute<T>(urlSring: String, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        
        guard let url = URL(string: urlSring)
        else {
            completion(.failure(ErrorCase.invalidURL))
            return
        }
        
        netWorkClient.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(ErrorCase.networkError(error)))
            }
            
            guard let data else {
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            }catch let error {
                completion(.failure(ErrorCase.networkError(error)))
            }
            
        }.resume()
    }
}