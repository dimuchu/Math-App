import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: SettingsViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    SettingsFormView(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            if viewModel == nil {
                viewModel = SettingsViewModel(modelContext: modelContext)
            }
        }
    }
}

private struct SettingsFormView: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Section("Training") {
                ForEach(MathOperation.allCases) { operation in
                    Toggle(operation.displayName, isOn: Binding(
                        get: { viewModel.isOperationEnabled(operation) },
                        set: { _ in viewModel.toggleOperation(operation) }
                    ))
                }

                Picker("Difficulty", selection: $viewModel.difficulty) {
                    ForEach(DifficultyRange.allCases) { range in
                        Text(range.displayName).tag(range)
                    }
                }
            }

            Section("Appearance") {
                Picker("Theme", selection: $viewModel.appearance) {
                    ForEach(AppAppearance.allCases) { appearance in
                        Text(appearance == .system ? "System (Default)" : appearance.displayName)
                            .tag(appearance)
                    }
                }
            }

            Section("Progress") {
                Button("Retake Diagnostic") {
                    viewModel.showRetakeDiagnostic = true
                }
                .foregroundStyle(MMColors.Semantic.accent)

                Button("Reset All Progress", role: .destructive) {
                    viewModel.showResetConfirmation = true
                }
            }

            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundStyle(MMColors.Text.secondary)
                }
            }
        }
        // Keep the last form rows scrollable above the floating tab bar.
        .contentMargins(.bottom, 120, for: .scrollContent)
        .safeAreaPadding(.bottom, 8)
        .confirmationDialog("Reset All Progress?", isPresented: $viewModel.showResetConfirmation, titleVisibility: .visible) {
            Button("Reset", role: .destructive) {
                Task { await viewModel.resetProgress() }
            }
        } message: {
            Text("This will delete all your skill ratings, streaks, and session history. This cannot be undone.")
        }
        .confirmationDialog("Retake Diagnostic?", isPresented: $viewModel.showRetakeDiagnostic, titleVisibility: .visible) {
            Button("Retake") {
                Task { await viewModel.retakeDiagnostic() }
            }
        } message: {
            Text("This will reset your skill ratings and restart the diagnostic. Your session history will be preserved.")
        }
    }
}
