import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query(sort: \SkillLevel.skillKey) private var skillLevels: [SkillLevel]

    @State private var showTraining = false
    @State private var showModeConfig = false
    @State private var selectedMode: TrainingMode?

    private var profile: UserProfile? { profiles.first }

    /// Aggregated skill ratings by operation
    private var operationSkills: [(operation: MathOperation, rating: Double)] {
        let grouped = Dictionary(grouping: skillLevels, by: \.operation)
        return MathOperation.allCases.compactMap { op in
            guard let levels = grouped[op], !levels.isEmpty else { return nil }
            let avg = levels.map { $0.clampedRating() }.reduce(0, +) / Double(levels.count)
            return (operation: op, rating: avg)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: MMSpacing.xl) {
                    // Streak badge
                    if let profile, profile.streakCount > 0 {
                        MMStreakBadge(count: profile.streakCount)
                            .padding(.top, MMSpacing.lg)
                    }

                    // Mode cards
                    VStack(spacing: MMSpacing.md) {
                        modeCard(
                            title: "Practice",
                            subtitle: "Train at your pace",
                            icon: "brain.head.profile"
                        ) {
                            selectedMode = .practice(count: AppSettings.shared.practiceCount)
                            showModeConfig = true
                        }

                        modeCard(
                            title: "Time Attack",
                            subtitle: "Race against time",
                            icon: "timer"
                        ) {
                            selectedMode = .timeAttack(seconds: AppSettings.shared.timeAttackSeconds)
                            showModeConfig = true
                        }
                    }
                    .padding(.horizontal, MMSpacing.lg)

                    // Skills overview
                    if !operationSkills.isEmpty {
                        VStack(alignment: .leading, spacing: MMSpacing.md) {
                            Text("Your Skills")
                                .font(MMFonts.title2)

                            ForEach(operationSkills, id: \.operation) { skill in
                                MMSkillBar(name: skill.operation.displayName, rating: skill.rating)
                            }
                        }
                        .padding(.horizontal, MMSpacing.lg)
                    } else {
                        emptySkillsPlaceholder
                    }
                }
                .padding(.bottom, MMSpacing.xxl)
            }
            .navigationTitle("MentalMath")
            .sheet(isPresented: $showModeConfig) {
                if let mode = selectedMode {
                    ModeConfigSheet(initialMode: mode) { configuredMode in
                        selectedMode = configuredMode
                        showModeConfig = false
                        showTraining = true
                    }
                    .presentationDetents([.medium])
                }
            }
            #if os(iOS)
            .fullScreenCover(isPresented: $showTraining) {
                if let mode = selectedMode {
                    TrainingView(mode: mode, modelContext: modelContext)
                }
            }
            #else
            .sheet(isPresented: $showTraining) {
                if let mode = selectedMode {
                    TrainingView(mode: mode, modelContext: modelContext)
                }
            }
            #endif
        }
        .onAppear {
            profile?.checkStreakValidity()
        }
    }

    private func modeCard(title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: MMSpacing.xs) {
                    Text(title)
                        .font(MMFonts.title2)
                        .foregroundStyle(MMColors.Text.primary)
                    Text(subtitle)
                        .font(MMFonts.callout)
                        .foregroundStyle(MMColors.Text.secondary)
                }

                Spacer()

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(MMColors.Semantic.accent)
            }
            .padding(MMSpacing.lg)
            .background(MMColors.Background.secondaryAdaptive, in: RoundedRectangle(cornerRadius: MMSpacing.cardCornerRadius))
        }
        .buttonStyle(.plain)
    }

    private var emptySkillsPlaceholder: some View {
        VStack(spacing: MMSpacing.sm) {
            Text("Complete your first session to see skills")
                .font(MMFonts.callout)
                .foregroundStyle(MMColors.Text.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, MMSpacing.lg)
        .padding(.top, MMSpacing.xl)
    }
}
