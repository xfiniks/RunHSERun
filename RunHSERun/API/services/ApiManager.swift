import Foundation
enum ApiType {
    
    case login
    case checkCode
    case createUser
    
    var baseURL : String {
        return "http://localhost:8000/"
    }
    
    var headers : [String : String] {
        switch self {
        case .login:
            return [:]
        case .checkCode:
            return [:]
        case .createUser:
            return [:]
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
    
    struct createUserRequestBody : Codable {
        let email : String
        let nickname : String
    }
    
    func createUser(nickname: String, email : String, complition : @escaping (AnswerType, UserInfo?) -> Void) {
        var request = ApiType.createUser.request
        print(email)
        print(nickname)
        let body = createUserRequestBody(email : email, nickname: nickname)
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
                            complition(.badJSON, nil)
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
}
