import Vapor
import SurrealClient

let environment = try Environment.detect()
let application = Application(environment)

// Or you can use environment variables so auth is not committed in code
application.surreal.configure(host: "http://localhost", port: 8000, username: "root", password: "root")

struct User: Codable, Content {
    let id: String
    let name: String
}

application.get("users") { request in
    let users: [SurrealResponse<[User]>] = try await request.surreal.query(namespace: "nodev", database: "nodev", query: "select * from user")
    return users.map { $0.result }
}

defer { application.shutdown() }
try application.run()
