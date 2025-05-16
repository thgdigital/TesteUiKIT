
import Foundation
@testable import TesteUiKIT

final class HomePresenterSpy: UserPresenting {
    
    private(set) var loadUserDataToBeReturned: [GitHubUser] = []
    private(set) var loadCallCount: Int = 0
    private(set) var loadUserDataCalled: Bool = false
    private(set) var didErrorCallCount: Int = 0
    private(set) var didErrorCalled: Bool = false
    private(set) var didErrorToBeReturned: Error?
    
    var items: [GitHubUser] = []
    
    func load(with users: [GitHubUser]) {
        loadUserDataToBeReturned = users
        loadCallCount += 1
        loadUserDataCalled = true
    }
    
    func didError(error: Error) {
        didErrorCallCount += 1
        didErrorToBeReturned = error
        didErrorCalled = true
    }
}


