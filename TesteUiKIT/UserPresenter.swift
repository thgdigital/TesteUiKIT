//
//  UserPresenter.swift
//  TesteUiKIT
//
//  Created by Thiago Santos on 14/05/25.
//
import Foundation

protocol UserPresenting {
    var items: [GitHubUser] { get }
    func load(with users: [GitHubUser])
}

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
