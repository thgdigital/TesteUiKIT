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