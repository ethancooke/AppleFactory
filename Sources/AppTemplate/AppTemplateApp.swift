import SwiftUI

@main
struct AppTemplateApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup("AppTemplate") {
            ContentView()
        }
        .windowResizability(.contentMinSize)
    }
}
