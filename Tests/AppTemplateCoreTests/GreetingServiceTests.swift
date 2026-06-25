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

    @Test("Reflects an updated message")
    func update() async {
        let service = GreetingService()
        await service.update(message: "hi there")
        let result = await service.greeting()
        #expect(result.message == "hi there")
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
