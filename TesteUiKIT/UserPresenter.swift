class UserPresenter: UserPresenting {
    
    private(set) var items: [GitHubUser] = []
    
    weak var view: HomeViewControllerProtocol?
    
    func load(with users: [GitHubUser]) {
        items = users
        DispatchQueue.main.async {
            self.view?.realodData()
        }
    }
    
}