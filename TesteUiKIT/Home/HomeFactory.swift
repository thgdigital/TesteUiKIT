import UIKit

class HomeFactory {
    
    static func make() -> HomeViewController {
        let webService = WebService()
        let userPresenter = UserPresenter()
        let interactor = UserInteractor(webService: webService, presenter: userPresenter)
        let viewController = HomeViewController(interactor: interactor)
        userPresenter.view = viewController
        return viewController
    }
}
