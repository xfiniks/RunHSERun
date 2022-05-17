import Foundation
import UIKit
import CoreMedia

enum ApiType {
    
    case login
    case checkCode
    case createUser
    case addFriend
    case deleteFriend
    case getUserByPattern
    case getFriends
    case getMe
    case renameUser
    case changeAvatar
    case getAudiences
    case putInQueue
    case putInQueueWithFriend
    case deleteFromQueue
    case deleteFromQueueWithFriend
    
    var baseURL : String {
        return "http://MacBook-Pro-Ivan-2.local:8000/"
    }
    
    var headers : [String : String] {
        switch self {
            case .login:
                return [:]
            case .checkCode:
                return [:]
            case .createUser:
                return [:]
            case .addFriend:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .deleteFriend:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .getUserByPattern:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .getFriends:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .getMe:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .renameUser:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .changeAvatar:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .getAudiences:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .putInQueue:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .putInQueueWithFriend:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .deleteFromQueue:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
            case .deleteFromQueueWithFriend:
                let defaults = UserDefaults()
                let token = defaults.string(forKey: "Token") ?? ""
                return ["Authorization" : "Bearer \(token)"]
        }
    }
    
    var path : String {
        switch self {
        case .login:
            return "auth/send-email"
        case .checkCode:
            return "auth/check-auth"
        case .createUser:
            return "auth/create-user"
        case .addFriend:
            return "api/friends/add-friend"
        case .deleteFriend:
            return "api/friends/delete-friend"
        case .getUserByPattern:
            return "api/users/get-by-nickname"
        case .getFriends:
            return "api/friends/get-friends"
        case .getMe:
            return "api/friends/get-me"
        case .renameUser:
            return "api/users/change-nickname"
        case .changeAvatar:
            return "api/users/change-profile-image"
        case .getAudiences:
            return "api/game/get-rooms-by-code"
        case .putInQueue:
            return "api/game/put-in-queue"
        case .putInQueueWithFriend:
            return "api/game/add-call"
        case .deleteFromQueue:
            return "api/game/delete-from-queue"
        case .deleteFromQueueWithFriend:
            return "api/game/delete-call"
        }
    }
    
    
    var request : URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL)!)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        switch self {
            case .login:
                request.httpMethod = "POST"
                return request
            case .checkCode:
                request.httpMethod = "POST"
                return request
            case .createUser:
                request.httpMethod = "POST"
                return request
            case .addFriend:
                request.httpMethod = "PUT"
                return request
            case .deleteFriend:
                request.httpMethod = "DELETE"
                return request
            case .getUserByPattern:
                request.httpMethod = "GET"
                return request
            case .getFriends:
                request.httpMethod = "GET"
                return request
            case .getMe:
                request.httpMethod = "GET"
                return request
            case .renameUser:
                request.httpMethod = "PUT"
                return request
            case .changeAvatar:
                request.httpMethod = "PUT"
                return request
            case .getAudiences:
                request.httpMethod = "GET"
                return request
            case .putInQueue:
                request.httpMethod = "PUT"
                return request
            case .putInQueueWithFriend:
                request.httpMethod = "PUT"
                return request
            case .deleteFromQueue:
                request.httpMethod = "DELETE"
                return request
            case .deleteFromQueueWithFriend:
                request.httpMethod = "DELETE"
                return request
        }
    }
}

class ApiManager {
    
    static let shared = ApiManager()
    
    func login(email : String, complition : @escaping (AnswerType, String?) -> Void) {
        var request = ApiType.login.request
        let body = ["email":"\(email)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(response)
            if error != nil {
                complition(.badInternet, nil)
            } else {
                if let httpresponce = response as? HTTPURLResponse {
                    switch httpresponce.statusCode {
                        case 200:
                            complition(.correctEmail, email)
                        case 400:
                            complition(.badEmail, nil)
                        default:
                            complition(.correctEmail, nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    struct checkCodeRequestBody : Codable {
        let email : String
        let code : Int
    }

    func checkCode(code: Int, email : String, complition : @escaping (AnswerType, UserInfo?) -> Void) {
        var request = ApiType.checkCode.request
        let body = checkCodeRequestBody(email : email, code: code)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                complition(.badInternet, nil)
            } else {
                if let httpresponce = response as? HTTPURLResponse {
                    switch httpresponce.statusCode {
                        case 200:
                            complition(.userCreate, nil)
                        case 201:
                            let jsonDecoder = JSONDecoder()
                            let userInfo = try? jsonDecoder.decode(UserInfo.self, from: data!)
                            complition(.userExist, userInfo)
                        case 400:
                            complition(.badJSON, nil)
                        case 401:
                            complition(.badCode, nil)
                        default:
                            complition(.badInternet, nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    struct UserRequestBody : Codable {
        let email : String
        let nickname : String
        let image : Int
    }
    
    func createUser(nickname: String, email : String, complition : @escaping (AnswerType, UserInfo?) -> Void) {
        var request = ApiType.createUser.request
        let body = UserRequestBody(email : email, nickname: nickname, image: 1)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                complition(.badInternet, nil)
            } else {
                if let httpresponce = response as? HTTPURLResponse {
                    switch httpresponce.statusCode {
                        case 201:
                            let jsonDecoder = JSONDecoder()
                            let userInfo = try? jsonDecoder.decode(UserInfo.self, from: data!)
                            complition(.userCreateSuccessfully, userInfo)
                        case 400:
                            complition(.incorrectNickname, nil)
                        case 409:
                            complition(.userAlreadyCreate, nil)
                        case 500:
                            complition(.nicknameAlreadyExists, nil)
                        default:
                            complition(.badInternet, nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    var searchScreenController : ApiSearchFriendsLogic?
    
    struct AddFriendRequestBody : Codable {
        let user_id : Int
    }
    
    var searchController : AddButtonLogic?
    
    func addFriendRequest(id : Int) {
        var request = ApiType.addFriend.request
        let body = AddFriendRequestBody(user_id: filteredUsers[id].id)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.searchScreenController?.showAlert(message: "Bad internet connection")
                } else {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 201:
                                self?.getUsersByPatternRequest(pattern: "")
                            case 400:
                                // JSON
                                self?.searchScreenController?.showAlert(message: "Bad internet connection")
                            case 401:
                                self?.searchScreenController?.moveToRegistration()
                            case 404:
                                self?.searchScreenController?.showAlert(message: "Cannot add user")
                            case 500:
                                // Server mistake
                                self?.searchScreenController?.showAlert(message: "Bad internet connection")
                            default:
                                self?.searchScreenController?.showAlert(message: "Bad internet connection")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    var users = [GameUser]()
    
    var filteredUsers : [GameUser] = [] {
        didSet {
            searchScreenController?.updateTable()
        }
    }
    
    func getUsersByPatternRequest(pattern : String) {
        var request = ApiType.getUserByPattern.request
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "nickname", value: pattern)]
        request.url = components?.url
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.searchScreenController?.showAlert(message: "Bad internet connection")
                } else {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 200:
                                let jsonDecoder = JSONDecoder()
                            if let data = data, let users = try? jsonDecoder.decode(Users.self, from: data ) {
                                var gameUsers = [GameUser]()
                                for user in users {
                                    gameUsers.append(GameUser(nickname: user.nickname, avatar: UIImage(named: "avatar\(user.image)")!, id : user.id))
                                }
                                self?.users = gameUsers
                                self?.getfriends()
                            } else {
                                self?.users = []
                                self?.getfriends()
                            }
                            case 401:
                                self?.searchScreenController?.moveToRegistration()
                            case 404:
                                self?.searchScreenController?.showAlert(message: "Bad internet connection")
                            default:
                                self?.searchScreenController?.showAlert(message: "Bad internet connection")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func filterUsers() {
        let defaults = UserDefaults()
        let nickname = defaults.string(forKey: "Nickname")!
        var newFilteredUsers = [GameUser]()
        for user in users {
            var flag = true
            for friend in friends {
                if (user.nickname.elementsEqual(friend.nickname) || user.nickname == nickname) {
                    flag = false
                    break
                }
            }
            if user.nickname == nickname {
                flag = false
            }
            if flag {
                newFilteredUsers.append(user)
            }
        }
        filteredUsers = newFilteredUsers
    }
    
    var friends = [GameUser]()
    
    var filteredFriends : [GameUser] = [] {
        didSet {
            if friendsGameController != nil {
            friendsGameController?.updateTable()
                
            }
            if StartGameWithFriendViewController != nil {
                StartGameWithFriendViewController?.updateTable()
            }
        }
    }
    
    var friendsGameController : ApiFriendsLogic?
    
    var StartGameWithFriendViewController : ApiFriendsLogic?
    
    func setFriends() {
        filteredFriends = friends
    }
    
    func getfriends() {
        let request = ApiType.getFriends.request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async { [weak self] in
                if error != nil {
                    if self?.friendsGameController != nil{
                    self?.friendsGameController?.showAlert(message: "Bad internet connection")
                    }
                    if self?.StartGameWithFriendViewController != nil {
                        self?.StartGameWithFriendViewController?.showAlert(message: "Bad internet connection")
                    }
                } else {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 200:
                                let jsonDecoder = JSONDecoder()
                                if let data = data, let users = try?
                                    jsonDecoder.decode(Users.self, from: data ) {
                                    var gameUsers = [GameUser]()
                                    for user in users {
                                        gameUsers.append(GameUser(nickname: user.nickname, avatar: UIImage(named: "avatar\(user.image)")!, id: user.id))
                                    }
                                    self?.friends = gameUsers
                                    self?.filterUsers()
                                    if self?.friendsGameController != nil {
                                        self?.setFriends()
                                    }
                                    if self?.StartGameWithFriendViewController != nil {
                                        self?.setFriends()
                                    }
                                } else {
                                    self?.friends = []
                                    self?.filterUsers()
                                    if self?.friendsGameController != nil {
                                        self?.setFriends()
                                    }
                                    if self?.StartGameWithFriendViewController != nil {
                                        self?.setFriends()
                                    }
                                }
                            case 401:
                            if self?.friendsGameController != nil{
                                self?.friendsGameController?.moveToRegistration()
                            }
                            if self?.StartGameWithFriendViewController != nil {
                                self?.StartGameWithFriendViewController?.moveToRegistration()
                            }
                            case 404:
                            if self?.friendsGameController != nil{
                            self?.friendsGameController?.showAlert(message: "Bad internet connection")
                            }
                            if self?.StartGameWithFriendViewController != nil {
                                self?.StartGameWithFriendViewController?.showAlert(message: "Bad internet connection")
                            }
                            case 500:
                            if self?.friendsGameController != nil{
                            self?.friendsGameController?.showAlert(message: "Bad internet connection")
                            }
                            if self?.StartGameWithFriendViewController != nil {
                                self?.StartGameWithFriendViewController?.showAlert(message: "Bad internet connection")
                            }
                            default:
                            if self?.friendsGameController != nil{
                            self?.friendsGameController?.showAlert(message: "Bad internet connection")
                            }
                            if self?.StartGameWithFriendViewController != nil {
                                self?.StartGameWithFriendViewController?.showAlert(message: "Bad internet connection")
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func filterFriends(pattern : String) {
        var newFilteredFriends = [GameUser]()
        if pattern == "" {
            filteredFriends = friends
        } else {
            newFilteredFriends = friends.filter({ (user : GameUser) -> Bool in
                return user.nickname.lowercased().contains(pattern.lowercased())
            })
        }
        filteredFriends = newFilteredFriends
    }
    
    func deleteFriend(id : Int) {
        var request = ApiType.deleteFriend.request
        let body = AddFriendRequestBody(user_id: filteredFriends[id].id)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    self!.friendsGameController?.showAlert(message: "Bad internet connection")
                } else {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 204:
                                self?.getfriends()
                                self?.setFriends()
                            case 400:
                                // JSON
                                self?.friendsGameController?.showAlert(message: "Bad internet connection")
                            case 401:
                                self?.friendsGameController?.moveToRegistration()
                            case 500:
                                // Server mistake
                                self?.friendsGameController?.showAlert(message: "Bad internet connection")
                            default:
                                self?.friendsGameController?.showAlert(message: "Bad internet connection")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    struct forNickname : Codable {
        let nickname : String
    }
    
    var settingsViewController : SettingsLogic?
    
    var gameScreenViewController : UserSettingsLogic?
    
    private func updateNickname(nickname : String) {
        let defaults = UserDefaults()
        defaults.setValue(nickname, forKey: "Nickname")
    }
    
    func changeNickname(nickname : String) {
        var request = ApiType.renameUser.request
        let body = forNickname(nickname: nickname)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    self!.settingsViewController?.showAlert(message: "Bad internet connection")
                } else {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 200:
                                self?.gameScreenViewController?.changeNickname(nickname: nickname)
                                self?.settingsViewController?.showSuccessAlert(message: "Nickname has been modified!")
                                self?.updateNickname(nickname: nickname)
                            case 401:
                                self?.settingsViewController?.moveToRegistration()
                            case 400:
                                // невалидный ник
                                self?.settingsViewController?.showAlert(message: "Incorrect nickname")
                            case 500:
                                // Server mistake
                                self?.settingsViewController?.showAlert(message: "Bad internet connection")
                            default:
                                self?.settingsViewController?.showAlert(message: "Bad internet connection")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    let avatarsCount = 5
    
    func makeAvatarId() -> Int {
        let defaults = UserDefaults()
        var avatarId = defaults.integer(forKey: "ImageId")
        if avatarId < avatarsCount {
            avatarId += 1
        } else {
            avatarId = 1
        }
        return avatarId
    }
    
    struct forAvatarChanging : Codable {
        let image : Int
    }
    
    private func changeDefaultsAvatar(id : Int) {
        let defaults = UserDefaults()
        defaults.setValue(id, forKey: "ImageId")
    }
    
    func changeAvatar() {
        var request = ApiType.changeAvatar.request
        let avatarId = makeAvatarId()
        let body = forAvatarChanging(image: avatarId)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    self!.settingsViewController?.showAlert(message: "Bad internet connection")
                } else {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 200:
                                self?.settingsViewController?.changeAvatar(id: avatarId)
                                self?.gameScreenViewController?.changeAvatar(id: avatarId)
                                self?.changeDefaultsAvatar(id: avatarId)
                            case 400:
                                self?.settingsViewController?.showAlert(message: "Bad internet connection")
                            case 500:
                                self?.settingsViewController?.showAlert(message: "Bad internet connection")
                            case 401:
                                self?.settingsViewController?.moveToRegistration()
                            default:
                                self?.settingsViewController?.showAlert(message: "Bad internet connection")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    var findAudienceViewController : ApiSearchRoomsLogic?
    
    var rooms = Rooms()
    
    var filteredRooms : Rooms = [] {
        didSet {
            findAudienceViewController?.updateTable()
        }
    }
    
    func filterRooms(pattern : String) {
        var newFilteredRooms = Rooms()
        if pattern == "" {
            filteredRooms = rooms
        } else {
            newFilteredRooms = rooms.filter({ (room : Room) -> Bool in
                return room.code.lowercased().contains(pattern.lowercased())
            })
        }
        newFilteredRooms.sort(by: {(first, second) -> Bool in
            if first.code.count == second.code.count {
                return first.code < second.code
            }
            return first.code.count < second.code.count
        })
        filteredRooms = newFilteredRooms
    }
    
    func getRoomsByPatternRequest(pattern : String) {
        var request = ApiType.getAudiences.request
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "code", value: pattern)]
        request.url = components?.url
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
                } else {
                    DispatchQueue.main.async {
                        if let httpresponce = response as? HTTPURLResponse {
                            switch httpresponce.statusCode {
                                case 200:
                                    let jsonDecoder = JSONDecoder()
                                if let data = data, let rooms = try? jsonDecoder.decode(Rooms.self, from: data) {
                                    self?.rooms = rooms
//                                    self?.filterRooms(pattern: pattern)
                                } else {
                                    self?.rooms = []
                                }
                                case 401:
                                    self?.findAudienceViewController?.moveToRegistration()
                                case 404:
                                    self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
                                default:
                                    self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    struct putInQueueBody : Codable {
        let room_id : Int
    }
    
    func putInQueue() {
        var request = ApiType.putInQueue.request
        let body = putInQueueBody(room_id: GameParameters.game.audience ?? 0)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if error != nil {
                self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
            } else {
                DispatchQueue.main.async {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 200:
                                self?.findAudienceViewController?.openWaitingScreen()
                            case 500:
                                self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
                            case 401:
                                self?.findAudienceViewController?.moveToRegistration()
                            case 400:
                                self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
                            default:
                                self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    struct putInQueueWithFriendBody : Codable {
        let room_id_first : Int
        let user_id_second : Int
    }
    
    func putInQueueWithFriend() {
        var request = ApiType.putInQueueWithFriend.request
        let body = putInQueueWithFriendBody(room_id_first: GameParameters.game.audience ?? 0, user_id_second: GameParameters.game.opponent ?? 0)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if error != nil {
                self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
            } else {
                DispatchQueue.main.async {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 200:
                                self?.findAudienceViewController?.openWaitingScreen()
                            case 201:
                                self?.findAudienceViewController?.openWaitingScreen()
                            case 500:
                                self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
                            case 404:
                                self?.findAudienceViewController?.showAlert(message: "Opponent does not exist")
                            case 401:
                                self?.findAudienceViewController?.moveToRegistration()
                            case 400:
                                self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
                            default:
                                self?.findAudienceViewController?.showAlert(message: "Bad internet connection")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    var waitingScreenController : ApiWaitingLogic?
    
    func deleteFromQueue() {
        let request = ApiType.deleteFromQueue.request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if error != nil {
                self?.waitingScreenController?.showAlert(message: "Bad internet connection")
            } else {
                DispatchQueue.main.async {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 204:
                                self?.waitingScreenController?.moveToMainScreen()
                                GameParameters.game.audience = nil
                            case 500:
                                self?.waitingScreenController?.showAlert(message: "Bad internet connection")
                            case 401:
                                self?.waitingScreenController?.moveToRegistration()
                            default:
                                self?.waitingScreenController?.showAlert(message: "Bad internet connection")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    struct deleteFromQueueBody : Codable {
        let user_id_second : Int
    }
    
    func deleteFromQueueWithFriend() {
        var request = ApiType.deleteFromQueueWithFriend.request
        let body = deleteFromQueueBody(user_id_second: GameParameters.game.opponent ?? 0)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(body)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if error != nil {
                self?.waitingScreenController?.showAlert(message: "Bad internet connection")
            } else {
                DispatchQueue.main.async {
                    if let httpresponce = response as? HTTPURLResponse {
                        switch httpresponce.statusCode {
                            case 204:
                                GameParameters.game.opponent = nil
                                GameParameters.game.audience = nil
                                self?.waitingScreenController?.moveToMainScreen()
                            case 500:
                                self?.waitingScreenController?.showAlert(message: "Bad internet connection")
                            case 404:
                                self?.waitingScreenController?.showAlert(message: "Opponent does not exist")
                            case 401:
                                self?.waitingScreenController?.moveToRegistration()
                            case 400:
                                self?.waitingScreenController?.showAlert(message: "Bad internet connection")
                            default:
                                self?.waitingScreenController?.showAlert(message: "Bad internet connection")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
}
