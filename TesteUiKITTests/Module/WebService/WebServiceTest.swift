//
//  WebServiceTest.swift
//  TesteUiKITTests
//
//  Created by Thiago Santos on 17/05/25.
//

import XCTest
@testable import TesteUiKIT

final class WebServiceTest: XCTestCase {
    let mock = MockNetworkClientSpy()
    lazy var sut = WebService(netWorkClient: mock)
    
    func test_Execute_WhenURLIsInvalid_ShouldReturnFailure(){
        
        //Given
        let json = Helper.shared.readJSONFile(mock: "githubUser")
        
        mock.jsonString = json
        
        let expectation = expectation(description: "Esperando retorno da chamada de rede")
        
        //when
        sut.execute(urlSring: "") { (result: Result<[GitHubUser], Error>) in
            switch result {
            case .success:
                XCTFail("Erro inesperado")
            case .failure(let failure):
                XCTAssertEqual(failure.localizedDescription, ErrorCase.invalidURL.localizedDescription)
            }
            expectation.fulfill()
        }
        
        //Then
        waitForExpectations(timeout: 1.0)
    }
    
    func test_Execute_WhenGivenValidJSON_ShouldReturnSuccessWithUsers(){
        
        //Given
        let json = Helper.shared.readJSONFile(mock: "githubUser")
        
        mock.jsonString = json
        
        let expectation = expectation(description: "Esperando retorno da chamada de rede")
        
        //when
        sut.execute(urlSring: "http://exemplo.com") { (result: Result<[GitHubUser], Error>) in
            
            switch result {
            case .success(let users):
                XCTAssertTrue(users.count > .zero)
            case .failure(let failure):
                XCTAssertEqual(failure.localizedDescription, ErrorCase.invalidURL.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        //Then
        waitForExpectations(timeout: 1.0)
    }
    
    func test_execute_WhenResponseIsInvalidJSON_shouldReturnDecodingFailure() {
        
        // Given
        mock.jsonString = ""
        let expectation = expectation(description: "Esperando retorno da chamada de rede")
        
        // When
        sut.execute(urlSring: "http://exemplo.com") { (result: Result<[GitHubUser], Error>) in
            
            // Then
            switch result {
            case .failure(let failure):
                if let error = failure as? ErrorCase,
                   case .networkError(let decodingError) = error {
                    XCTAssertTrue(
                        decodingError.localizedDescription.contains("not valid JSON") ||
                        decodingError.localizedDescription.contains("Unexpected end of file") ||
                        decodingError.localizedDescription.contains("it isn’t in the correct format")
                        ,
                        "Esperava erro de parsing de JSON, mas recebeu: \(decodingError)"
                    )
                } else {
                    XCTFail("Erro não era ErrorCase.networkError: \(failure)")
                }
            case .success(let users):
                XCTFail("Esperado falha, mas retornou sucesso com: \(users)")
            }

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
