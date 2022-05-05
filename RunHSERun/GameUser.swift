import Foundation
import UIKit

class GameUser {
    
    let nickname : String
    let avatar : UIImage?
    
    init(nickname : String, avatar : UIImage) {
        self.nickname = nickname
        self.avatar = avatar
    }
}
