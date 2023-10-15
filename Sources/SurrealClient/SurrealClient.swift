import Vapor

public struct SurrealResponse<T: Codable>: Codable {
    public let time: String
    public let status: String
    public let result: T
}

public struct SurrealError: Codable, Error {
    public let code: Int
    public let details: String
    public let description: String
    public let information: String

    init(code: Int, details: String, description: String, information: String) {
        self.code = code
        self.details = details
        self.description = description
        self.information = information
    }

    init(code: Int, description: String) {
        self.code = code
        self.details = description
        self.description = description
        self.information = description
    }
}

extension Application.Surreal {
    /// Surreal returns an array of responses
    public func query<T: Codable>(namespace: String, database: String, query: String) async throws -> [SurrealResponse<T>] {
        let response = try await application.client.post(URI(stringLiteral: address), headers: [
            "Authorization": authorization,
            "NS": namespace,
            "DB": database,
            "Accept": "application/json"
        ], content: query)

        guard let body = response.body else {
            throw SurrealError(code: 500, description: "Surreal response missing body")
        }

        if let error = try? decoder.decode(SurrealError.self, from: body) {
            throw error
        }

        return try decoder.decode([SurrealResponse<T>].self, from: body)
    }
}
