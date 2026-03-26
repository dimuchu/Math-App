import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: StatisticsViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    content(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Statistics")
        }
        .onAppear {
            if viewModel == nil {
                viewModel = StatisticsViewModel(modelContext: modelContext)
            }
            Task { await viewModel?.load() }
        }
    }

    private func content(viewModel: StatisticsViewModel) -> some View {
        ScrollView {
            VStack(spacing: MMSpacing.xl) {
                // Hero metrics row
                HStack(spacing: MMSpacing.xl) {
                    heroMetric(value: "\(viewModel.totalSolved)", label: "Solved")
                    heroMetric(value: "\(Int(viewModel.overallAccuracy * 100))%", label: "Accuracy")
                    HStack(spacing: MMSpacing.xs) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(MMColors.Semantic.streak)
                            .font(.caption)
                        heroMetric(value: "\(viewModel.streakCount)", label: "Streak")
                    }
                }
                .padding(.top, MMSpacing.lg)

                // Skill levels
                if !viewModel.operationSkills.isEmpty {
                    VStack(alignment: .leading, spacing: MMSpacing.md) {
                        Text("Skill Levels")
                            .font(MMFonts.title2)

                        ForEach(viewModel.operationSkills, id: \.operation) { skill in
                            MMSkillBar(name: skill.operation.displayName, rating: skill.rating)
                        }
                    }
                    .padding(.horizontal, MMSpacing.lg)
                }

                // Recent sessions
                if viewModel.recentSessions.isEmpty {
                    Text("Complete your first session to see stats")
                        .font(MMFonts.callout)
                        .foregroundStyle(MMColors.Text.tertiary)
                        .padding(.top, MMSpacing.xxl)
                } else {
                    VStack(alignment: .leading, spacing: MMSpacing.md) {
                        Text("Recent Sessions")
                            .font(MMFonts.title2)
                            .padding(.horizontal, MMSpacing.lg)

                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.recentSessions, id: \.startDate) { session in
                                SessionRowView(session: session)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, MMSpacing.xxl)
        }
    }

    private func heroMetric(value: String, label: String) -> some View {
        VStack(spacing: MMSpacing.xs) {
            Text(value)
                .font(MMFonts.title1)
                .foregroundStyle(MMColors.Text.primary)
            Text(label)
                .font(MMFonts.caption)
                .foregroundStyle(MMColors.Text.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
