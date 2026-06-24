import Foundation

public actor GreetingService {
    public init() {}

    public func greeting() -> Greeting {
        Greeting(message: "Hello from AppTemplate")
    }
}
