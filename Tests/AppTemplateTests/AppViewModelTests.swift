import Testing
@testable import AppTemplate
@testable import AppTemplateCore

// Demonstrates testing @MainActor @Observable UI-adjacent logic: inject a service, drive the
// view model, assert its observable state. The whole suite runs on the main actor because the
// view model is @MainActor-isolated.
@Suite("AppViewModel")
@MainActor
struct AppViewModelTests {

    @Test("Loads the greeting from the injected service")
    func loadGreeting() async {
        let viewModel = AppViewModel(service: GreetingService(message: "Hi from the test"))
        #expect(viewModel.greeting == nil)

        await viewModel.loadGreeting()

        #expect(viewModel.greeting?.message == "Hi from the test")
    }

    @Test("Increment and reset update the count")
    func counter() {
        let viewModel = AppViewModel()
        #expect(viewModel.count == 0)

        viewModel.increment()
        viewModel.increment()
        #expect(viewModel.count == 2)

        viewModel.reset()
        #expect(viewModel.count == 0)
    }
}
