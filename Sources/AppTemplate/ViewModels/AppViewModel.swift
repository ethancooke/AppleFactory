import AppTemplateCore
import SwiftUI

@MainActor
@Observable
final class AppViewModel {
    var greeting: Greeting?
    var count: Int = 0

    private let service: GreetingService

    init(service: GreetingService = GreetingService()) {
        self.service = service
    }

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
