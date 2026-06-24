import SwiftUI
import AppTemplateCore

@MainActor
@Observable
final class AppViewModel {
    var greeting: Greeting?
    var count: Int = 0

    private let service = GreetingService()

    func loadGreeting() async {
        greeting = await service.greeting()
    }

    func increment() {
        count += 1
    }

    func reset() {
        count = 0
    }
}
