import Vapor

extension Application {
    public struct Surreal {
        let application: Application
    }

    public var surreal: Surreal { Surreal(application: self) }
}

extension Request {
    public var surreal: Application.Surreal { Application.Surreal(application: application) }
}

// MARK: - Helpers

extension Application.Surreal {
    struct AddressKey: StorageKey {
        typealias Value = String
    }

    var address: String {
        get throws {
            if let existing = application.storage[AddressKey.self] {
                return existing
            }

            guard let host = Environment.get("SURREAL_HOST") else {
                throw SurrealError(code: 500, description: "SURREAL_HOST environment variable missing.")
            }

            guard let port = Environment.get("SURREAL_PORT") else {
                throw SurrealError(code: 500, description: "SURREAL_PORT environment variable missing.")
            }

            let address = "\(host):\(port)/sql"
            application.storage[AddressKey.self] = address
            return address
        }
    }

    struct AuthorizationKey: StorageKey {
        typealias Value = String
    }

    var authorization: String {
        get throws {
            if let existing = application.storage[AuthorizationKey.self] {
                return existing
            }

            guard let username = Environment.get("SURREAL_USER") else {
                throw SurrealError(code: 500, description: "SURREAL_USER environment variable missing.")
            }

            guard let password = Environment.get("SURREAL_PASSWORD") else {
                throw SurrealError(code: 500, description: "SURREAL_PASSWORD environment variable missing.")
            }

            let token = "\(username):\(password)".base64String()
            let authorization = "Basic \(token)"
            application.storage[AuthorizationKey.self] = authorization
            return authorization
        }
    }

    struct DecoderKey: StorageKey {
        typealias Value = JSONDecoder
    }

    public var decoder: JSONDecoder {
        get {
            if let existing = application.storage[DecoderKey.self] {
                return existing
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.iso8601Full)
            // TODO: configure decoder as data/data options are explored
            application.storage[DecoderKey.self] = decoder
            return decoder
        }

        nonmutating set {
            application.storage[DecoderKey.self] = newValue
        }
    }

    public func configure(host: String, port: Int, username: String, password: String) {
        let address = "\(host):\(port)/sql"
        application.storage[AddressKey.self] = address

        let token = "\(username):\(password)".base64String()
        let authorization = "Basic \(token)"
        application.storage[AuthorizationKey.self] = authorization
    }
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
