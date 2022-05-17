import Foundation

@objc
protocol ObservableProtocol: AnyObject { }

protocol Observable {
    
    associatedtype Observer: ObservableProtocol
    var observers: [Observer] { get set }
    
    mutating func add(observer: Observer)
    mutating func remove(observer: Observer)
    func notifyObservers(_ block: (Observer) -> Void)
}

extension Observable {
    mutating func add(observer: Observer) {
        if !self.observers.contains(where: { observer === $0 }) {
            self.observers.append(observer)
        }
    }
    
    mutating func remove(observer: Observer) {
        for (index, entry) in observers.enumerated() {
            if entry === observer {
                observers.remove(at: index)
                return
            }
        }
    }
    
    func notifyObservers(_ block: (Observer) -> Void) {
        observers.forEach { (observer) in
            block(observer)
        }
    }
}
