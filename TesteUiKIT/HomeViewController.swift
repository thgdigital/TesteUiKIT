//
//  ViewController.swift
//  TesteUiKIT
//
//  Created by Thiago Santos on 14/05/25.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func realodData()
}

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
        view.backgroundColor = .white
        interactor.loadView()
    }
}


extension HomeViewController: HomeViewControllerProtocol {
    func realodData() {
  
        print("Aqui recarrego os dados")
    }
}
