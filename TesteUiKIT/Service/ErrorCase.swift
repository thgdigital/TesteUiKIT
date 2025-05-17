import Foundation

enum ErrorCase: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .networkError(let underlyingError):
            return "Erro de rede: \(underlyingError.localizedDescription)"
        case .invalidResponse:
            return "Response inválido"
        case .invalidData:
            return "Json Inválid"
        }
    }
}

extension ErrorCase: Equatable {
    
    static func == (lhs: ErrorCase, rhs: ErrorCase) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
            (.invalidData, .invalidData):
            return true
        case let (.networkError(lhsError), .networkError(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
