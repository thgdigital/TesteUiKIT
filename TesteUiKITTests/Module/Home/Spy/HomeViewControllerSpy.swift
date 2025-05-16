import Foundation
@testable import TesteUiKIT

final class HomeViewControllerSpy: HomeViewControllerProtocol {
    private(set) var realodDataCalled: Bool = false
    private(set) var reloadCalldOnce: Int = 0
    private(set) var didErrorCalled: Bool = false
    private(set) var didErrorMessage: String?
    private(set) var didErrorCallOnce: Int = 0
    var onReloadData: (() -> Void)?
    
    func realodData() {
        realodDataCalled = true
        reloadCalldOnce += 1
        onReloadData?()
    }
    
    func didError(message: String) {
        didErrorCalled = true
        didErrorMessage = message
        didErrorCallOnce += 1
    }
    
}
