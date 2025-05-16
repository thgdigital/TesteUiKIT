import Foundation

protocol UserInteractorProtocol: AnyObject {
    func loadView()
    func loadView() async
}

class UserInteractor: UserInteractorProtocol {
    let webService: WebServiceProtocol
    let presenter: UserPresenting
    
    init(webService: WebServiceProtocol, presenter: UserPresenting) {
        self.webService = webService
        self.presenter = presenter
    }
    
    func loadView() {
        webService.execute(urlSring: "https://api.github.com/users") { [weak self] (result: Result<[GitHubUser], Error>) in
            switch result {
            case .success(let users):
                self?.presenter.load(with: users)
            case .failure(let failure):
                self?.presenter.didError(error: failure)
            }
        }
    }
    
    func loadView() async {
        do {
            let result: [GitHubUser] = try await webService.execute(urlSring: "https://api.github.com/users")
            presenter.load(with: result)
            print(result)
        } catch {
            presenter.didError(error: error)
        }
    }
}
