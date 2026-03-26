import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: OnboardingViewModel?
    @State private var currentPage = 0

    var body: some View {
        Group {
            if let viewModel {
                switch viewModel.step {
                case .welcome:
                    welcomePages(viewModel: viewModel)
                case .diagnostic:
                    DiagnosticView(viewModel: viewModel)
                case .diagnosticResults:
                    DiagnosticResultsView(viewModel: viewModel)
                }
            } else {
                VStack(spacing: MMSpacing.md) {
                    ProgressView()
                    Text("Preparing onboarding...")
                        .font(MMFonts.callout)
                        .foregroundStyle(MMColors.Text.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(MMColors.Background.primaryAdaptive)
            }
        }
        .task {
            if viewModel == nil {
                viewModel = OnboardingViewModel(modelContext: modelContext)
            }
        }
    }

    private func welcomePages(viewModel: OnboardingViewModel) -> some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $currentPage) {
                onboardingPage(
                    icon: "brain.head.profile",
                    title: "Train Your Mental Math",
                    description: "Quick, focused practice to sharpen your mental arithmetic skills."
                )
                .tag(0)

                onboardingPage(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Find Your Level",
                    description: "Solve a few problems and we'll assess your skills to create a personalized training plan."
                )
                .tag(1)
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .always))
            #endif

            Button("Skip") {
                viewModel.skip()
            }
            .font(MMFonts.callout)
            .foregroundStyle(MMColors.Text.secondary)
            .padding(.horizontal, MMSpacing.xl)
            .padding(.top, MMSpacing.lg)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                if currentPage == 0 {
                    withAnimation { currentPage = 1 }
                } else {
                    viewModel.startDiagnostic()
                }
            } label: {
                Text(currentPage == 0 ? "Continue" : "Start Diagnostic")
                    .font(MMFonts.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, MMSpacing.md)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, MMSpacing.xl)
            .padding(.bottom, MMSpacing.lg)
        }
    }

    private func onboardingPage(icon: String, title: String, description: String) -> some View {
        VStack(spacing: MMSpacing.xl) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundStyle(MMColors.Semantic.accent)

            Text(title)
                .font(MMFonts.title1)
                .multilineTextAlignment(.center)

            Text(description)
                .font(MMFonts.body)
                .foregroundStyle(MMColors.Text.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, MMSpacing.xxl)

            Spacer()
            Spacer()
        }
    }
}
