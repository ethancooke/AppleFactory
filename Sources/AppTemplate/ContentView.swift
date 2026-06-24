import SwiftUI
import AppTemplateCore

struct ContentView: View {
    @State private var viewModel = AppViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.greeting?.message ?? "Loading…")
                .font(.title)

            Text("\(viewModel.count)")
                .font(.system(size: 64, weight: .bold, design: .rounded))

            HStack(spacing: 16) {
                Button("Increment") { viewModel.increment() }
                Button("Reset") { viewModel.reset() }
                    .disabled(viewModel.count == 0)
            }
        }
        .frame(minWidth: 420, minHeight: 320)
        .padding(40)
        .task { await viewModel.loadGreeting() }
    }
}
