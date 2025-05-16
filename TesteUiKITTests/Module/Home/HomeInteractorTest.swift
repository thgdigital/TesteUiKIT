//
//  HomeInteractorTest.swift
//  TesteUiKITTests
//
//  Created by Thiago Santos on 15/05/25.
//

import XCTest
@testable import TesteUiKIT

final class HomeInteractorTest: XCTestCase {
    
    let mockService = MockNetworkClientSpy(scenario: .success, jsonString: "")
    
    let presenterSpy = HomePresenterSpy()
    
    lazy var serviceMock = WebService(netWorkClient: mockService)
    
    lazy var sut = UserInteractor(webService: serviceMock, presenter: presenterSpy)
    
    func test_shoudCallServiceLoadView() {
        // Given
        mockService.jsonString = readJSONFile(mock: "githubUser")
        
        //When
        sut.loadView()
        
        // Then
        XCTAssertTrue(presenterSpy.loadUserDataCalled)
        XCTAssertEqual(presenterSpy.loadCallCount, 1)
        XCTAssertEqual(presenterSpy.loadUserDataToBeReturned.count, 30)
    }
    
    func test_when_ShoudCallServiceLoadView_and_Fail() {
        //Given
        mockService.scenario = .throwError
        let error = NSError(domain: "MockError", code: 1, userInfo: nil)
        
        //when
        sut.loadView()
        
        //then
        XCTAssertTrue(presenterSpy.didErrorCalled)
        XCTAssertEqual(presenterSpy.didErrorCallCount, 1)
        XCTAssertEqual(presenterSpy.didErrorToBeReturned?.localizedDescription, error.localizedDescription)
    }
    
    // MARK: - Helper Methods
    private func readJSONFile(mock: String) -> String {
        
        let bundle = Bundle(for: type(of: self))
        
        guard let pathString = bundle.path(forResource: mock, ofType: "json") else {
            fatalError("UnitTestData.json not found")
        }
        
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to String")
        }
        return jsonString
    }
    
}
