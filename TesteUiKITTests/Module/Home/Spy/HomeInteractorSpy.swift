import Foundation
@testable import TesteUiKIT

final class HomeInteractorSpy: UserInteractorProtocol {
    private(set) var loadViewCalled = false
    private(set) var loadViewCalledCount = 0
    private(set) var loadViewAsyncCalled = false
    private(set) var loadViewAsyncCalledCount = 0
    
    func loadView() {
        loadViewCalled = true
        loadViewCalledCount += 1
    }
    
    func loadView() async {
        loadViewAsyncCalled = true
        loadViewAsyncCalledCount += 1
    }
}
