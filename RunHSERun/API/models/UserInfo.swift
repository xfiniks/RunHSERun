import Foundation

// MARK: - UserInfo
struct UserInfo: Codable {
    let token: String
    let user: User
}

// MARK: - User
struct User: Codable {
    let id: Int
    let nickname, email: String
    let image : Int
}

typealias Users = [User]

