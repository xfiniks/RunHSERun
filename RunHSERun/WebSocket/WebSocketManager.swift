import UIKit

@objc
protocol SocketObservable: ObservableProtocol {
    @objc
    func didConnect()
    
    @objc
    func didDisconnect()
    
    @objc
    func handleError(_ error: String)

    @objc
    optional func logSignal(_ signal: String?)
}

final class WebSocketManager: NSObject, Observable {
    
    private enum NetworkEnvironment {
        case debug
        case master
    }
    
    // MARK: - Singletone
    static var shared = WebSocketManager()

    // MARK: - Properties
    var observers: [SocketObservable] = []
    
    private let environment: NetworkEnvironment = .master
    private var session: URLSession!
    private var webSocketTask: URLSessionWebSocketTask!
    private var isConnected: Bool = false
    
    private var baseURL: String {
        switch self.environment {
        case .debug: return "ws://0.0.0.0:8080/echo"
        case .master: return "ws://MacBook-Pro-Ivan-2.local:8000/api/upgrade-connection"
        }
    }
    
    // MARK: - Behavior
    func connect() {
        guard !self.isConnected else { return }
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: URL(string: self.baseURL)!)
        let defaults = UserDefaults()
        let token = defaults.string(forKey: "Token") ?? ""
        request.allHTTPHeaderFields = ["Authorization" : "Bearer \(token)"]
        self.webSocketTask = self.session.webSocketTask(with: request)
        self.webSocketTask.resume()
    }
    
    var needSendPing = false
    
    func sendPing() {
        self.webSocketTask.sendPing { (error) in
            if let error = error {
                print("Sending PING failed: \(error)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if self.needSendPing {
                    self.sendPing()
                }
//                self.connect()
            }
        }
    }
    
    func disconnect() {
        guard self.isConnected else { return }
        self.webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    func sendSignal(message: String) {
        self.webSocketTask.send(.string(message)) { [weak self] error in
            guard let error = error else { return }
            self?.handleError(error.localizedDescription)
        }
    }

    // MARK: - Private configuration
    private func connected() {
        self.notifyObservers { observers in
            observers.didConnect()
        }
        self.subscribe()
    }
    
    private func subscribe() {
        self.webSocketTask.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.isConnected = false
//                self?.sendPing()
                self?.connect()
                self?.handleError("Failed to receive message: \(error.localizedDescription)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.logSignal("Received text message: \(text)")
                case .data(let data):
                    print("Received binary message: \(data)")
                @unknown default:
                    fatalError()
                }
            }
            
            self?.subscribe()
        }
    }
    
    private func disconnected() {
        self.notifyObservers { observers in
            observers.didDisconnect()
        }
    }
    
    private func handleError(_ errorMessage: String) {
        self.notifyObservers { observers in
            observers.handleError(errorMessage)
        }
    }
    
    private func logSignal(_ message: String?) {
        self.notifyObservers { observers in
            observers.logSignal?(message)
        }
    }
    
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        needSendPing = true
        sendPing()
        self.isConnected = true
        self.connected()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.isConnected = false
        needSendPing = false
        self.disconnected()
    }
}
