// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userInfo = try? newJSONDecoder().decode(UserInfo.self, from: jsonData)

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
}
