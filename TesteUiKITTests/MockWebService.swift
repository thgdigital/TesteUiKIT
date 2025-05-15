//
//  MockWebService.swift
//  TesteUiKITTests
//
//  Created by Thiago Santos on 14/05/25.
//

import Foundation
@testable import TesteUiKIT

class MockNetworkClient: NetworkClientProtocol {
    
    var scenario: MockScenario
    var jsonString: String
    
    init(scenario: MockScenario, jsonString: String) {
        self.scenario = scenario
        self.jsonString = jsonString
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
        
        return MockURLSessionDataTask {
            
            guard let urlRequest = request.url else {
                completionHandler(nil, nil, ErrorCase.invalidURL)
                return
            }
            
            switch self.scenario {
                
            case .success:
                let data = Data(self.jsonString.utf8)
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                completionHandler(data, response, nil)
                
            case .invalidResponse:
                completionHandler(nil, nil, ErrorCase.invalidResponse)
                
            case .badJSON:
                let data = Data("{".utf8)
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                completionHandler(data, response, nil)
                
            case .throwError:
                completionHandler(nil, nil, NSError(domain: "MockError", code: 1, userInfo: nil))
            }
        }
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let urlRequest = request.url else {
            throw ErrorCase.invalidURL
        }
        
        switch scenario {
        case .success:
            let data = Data(jsonString.utf8)
            let response = HTTPURLResponse(url: urlRequest, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (data, response)
        case .invalidResponse:
            let data = Data()
            let response = HTTPURLResponse(url: urlRequest, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (data, response)
        case .badJSON:
            let data = Data(jsonString.utf8)
            let response = HTTPURLResponse(url: urlRequest, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (data, response)
        case .throwError:
            throw URLError(.notConnectedToInternet)
        }
    }
    
    
    enum MockScenario {
        case success, invalidResponse, badJSON, throwError
    }
}

@available(iOS, deprecated: 13.0, message: "Mocked class for testing only")
class MockURLSessionDataTask: URLSessionDataTask, @unchecked Sendable {
    private let onResume: () -> Void
    
    init(onResume: @escaping () -> Void) {
        self.onResume = onResume
        super.init()
    }
    
    override func resume() {
        onResume()
    }
}
