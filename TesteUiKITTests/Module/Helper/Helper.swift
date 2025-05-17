//
//  Helper.swift
//  TesteUiKITTests
//
//  Created by Thiago Santos on 17/05/25.
//

import Foundation

class Helper {
    
    static let shared = Helper()

    private init() { }
    
    // MARK: - Helper Methods
     func readJSONFile(mock: String) -> String {
        
        let bundle = Bundle(for: type(of: self))
        
        guard let pathString = bundle.path(forResource: mock, ofType: "json") else {
            fatalError("UnitTestData.json not found")
        }
        
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to String")
        }
        return jsonString
    }
}
