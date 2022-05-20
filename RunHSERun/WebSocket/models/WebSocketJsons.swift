import Foundation

// MARK: - AudienceStructure
struct AudienceStructure: Codable {
    let nickname: String
    let gameID: Int
    let rooms: [Room]

    enum CodingKeys: String, CodingKey {
        case nickname
        case gameID = "game_id"
        case rooms
    }
}

// MARK: - ResultsStructure
struct ResultsStructure: Codable {
    let gameResult: String

    enum CodingKeys: String, CodingKey {
        case gameResult = "game_result"
    }
}


