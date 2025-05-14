//
//  UserInteractor.swift
//  TesteUiKIT
//
//  Created by Thiago Santos on 14/05/25.
//


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
                print(failure.localizedDescription)
            }
        }
    }
}