import Testing
@testable import AppTemplateCore

@Suite("GreetingService")
struct GreetingServiceTests {

    @Test("Returns a non-empty greeting")
    func greeting() async {
        let service = GreetingService()
        let result = await service.greeting()
        #expect(!result.message.isEmpty)
    }
}

@Suite("Greeting")
struct GreetingTests {

    @Test("Stores its message and is Sendable")
    func message() {
        let greeting = Greeting(message: "hi")
        #expect(greeting.message == "hi")
    }
}
