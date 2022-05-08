import Foundation
import UIKit

class GameUser {
    
    let nickname : String
    let avatar : UIImage?
    let id : Int
    
    init(nickname : String, avatar : UIImage, id : Int) {
        self.nickname = nickname
        self.avatar = avatar
        self.id = id
    }
}
