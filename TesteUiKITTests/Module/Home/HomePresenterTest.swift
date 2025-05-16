//
//  HomePresenterTest.swift
//  TesteUiKITTests
//
//  Created by Thiago Santos on 16/05/25.
//

import XCTest
@testable import TesteUiKIT

final class HomePresenterTest: XCTestCase {
    let spy = HomeViewControllerSpy()
    let sut = UserPresenter()
    
    func testLoadUsers_whenGivenValidList_shouldReload() {
        sut.view = spy
        
        let users: [GitHubUser] = [.fixture(login: "faixinha")]
        
        let expectation = expectation(description: "Esperando chamada do reloadData")
        
        spy.onReloadData = {
            expectation.fulfill()
        }
        
        sut.load(with: users)

        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(spy.realodDataCalled, "Esta função dever ser chamada")
    }
    
    func testLoadUsers_WhenInvalidURL_ShouldShowError(){
        //Given
        sut.view = spy

        //when
        sut.didError(error: ErrorCase.invalidURL)
        
        //Then
        XCTAssertEqual(spy.didErrorMessage, ErrorCase.invalidURL.localizedDescription)
    }
  
}



