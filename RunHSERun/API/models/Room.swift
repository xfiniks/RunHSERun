import Foundation

struct Room: Codable {
    let id: Int
    let code: String
    let campus_id : Int
}

typealias Rooms = [Room]
