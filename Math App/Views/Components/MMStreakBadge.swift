import SwiftUI

struct MMStreakBadge: View {
    let count: Int

    @State private var isPulsing = false

    private var streakText: String {
        count == 1 ? "day streak" : "days streak"
    }

    var body: some View {
        HStack(spacing: MMSpacing.sm) {
            Image(systemName: "flame.fill")
                .foregroundStyle(MMColors.Semantic.streak)
                .font(.title2)
                .scaleEffect(isPulsing ? 1.1 : 1.0)

            Text("\(count)")
                .font(MMFonts.title2)
                .foregroundStyle(MMColors.Text.primary)

            Text(streakText)
                .font(MMFonts.caption)
                .foregroundStyle(MMColors.Text.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(count) \(streakText)")
        .onAppear {
            guard count > 0 else { return }
            withAnimation(MMAnimation.streakPulse) {
                isPulsing = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MMStreakBadge(count: 7)
        MMStreakBadge(count: 1)
        MMStreakBadge(count: 0)
    }
}
