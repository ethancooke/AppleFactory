import Foundation

public struct Greeting: Sendable {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}
