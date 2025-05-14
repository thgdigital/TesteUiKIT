//
//  ViewController.swift
//  TesteUiKIT
//
//  Created by Thiago Santos on 14/05/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    let interactor: UserInteractorProtocol
    
    init(interactor: UserInteractorProtocol) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        interactor.loadView()
    }

}


protocol UserInteractorProtocol: AnyObject {
    func loadView()
}

class UserInteractor: UserInteractorProtocol {
    let webService: FetchUserRequest
    let presenter: UserPresenting
    
    init(webService: FetchUserRequest, presenter: UserPresenting) {
        self.webService = webService
        self.presenter = presenter
    }
    
    
    func loadView() {
        
        webService.execute { [weak self] result in
            switch result {
            case .success(let users):
                self?.presenter.load(with: users)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

protocol UserPresenting {
    func load(with user: [GitHubUser])
}

class UserPresenter: UserPresenting {
    func load(with user: [GitHubUser]) {
        DispatchQueue.main.async {
            print(user)
        }
        
    }
    
}

protocol NetworkClientProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask
}

protocol FetchUserRequest {
    func execute(completion: @escaping (Result<[GitHubUser], any Error>) ->Void)
}

extension URLSession: NetworkClientProtocol {}


class WebService: FetchUserRequest {

        
    let netWorkClient: NetworkClientProtocol
    
    init(netWorkClient: NetworkClientProtocol = URLSession.shared) {
        self.netWorkClient = netWorkClient
    }
    
    
    func execute(completion: @escaping (Result<[GitHubUser], any Error>) ->Void) {
        guard let url = URL(string: "https://api.github.com/users")
        else {
            completion(.failure(ErrorCase.invalidURL))
            return
        }
        netWorkClient.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(ErrorCase.networkError(error)))
            }
            
            guard let data else {
                return
            }
            
            do {
                let users = try JSONDecoder().decode([GitHubUser].self, from: data)
                completion(.success(users))
            }catch let error {
                completion(.failure(ErrorCase.networkError(error)))
            }
            
        }.resume()
    }
}

public struct GitHubUser: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url: String
    let htmlURL: String
    let followersURL: String
    let followingURL: String
    let gistsURL: String
    let starredURL: String
    let subscriptionsURL: String
    let organizationsURL: String
    let reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let userViewType: String
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case userViewType = "user_view_type"
        case siteAdmin = "site_admin"
    }
}

enum ErrorCase: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .networkError(let underlyingError):
            return "Erro de rede: \(underlyingError.localizedDescription)"
        case .invalidResponse:
            return "Response inválido"
        }
    }
    
}


class HomeFactory {
    static func make() -> ViewController {
        let webService = WebService()
        let userPresenter = UserPresenter()
        let interactor = UserInteractor(webService: webService, presenter: userPresenter)
        let viewController = ViewController(interactor: interactor)
        return viewController
    }
}
