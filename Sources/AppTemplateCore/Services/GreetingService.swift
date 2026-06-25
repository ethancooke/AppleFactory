import Foundation

/// An actor-isolated service. The `actor` is what protects `message` from concurrent
/// mutation — use this pattern for services that own mutable state. A purely stateless
/// helper would be a plain `struct` instead.
public actor GreetingService {
    private var message: String

    public init(message: String = "Hello from AppTemplate") {
        self.message = message
    }

    public func greeting() -> Greeting {
        Greeting(message: message)
    }

    public func update(message: String) {
        self.message = message
    }
}
