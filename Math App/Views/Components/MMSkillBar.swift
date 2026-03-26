import SwiftUI

struct MMSkillBar: View {
    let name: String
    let rating: Double

    @State private var animatedRating: Double = 0

    private var percentage: Int {
        Int(animatedRating * 100)
    }

    var body: some View {
        VStack(spacing: MMSpacing.xs) {
            HStack {
                Text(name)
                    .font(MMFonts.caption)
                    .foregroundStyle(MMColors.Text.secondary)
                Spacer()
                Text("\(percentage)%")
                    .font(MMFonts.caption)
                    .foregroundStyle(MMColors.Text.secondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: MMSpacing.skillBarCornerRadius)
                        .fill(MMColors.Background.tertiaryAdaptive)
                        .frame(height: MMSpacing.skillBarHeight)

                    RoundedRectangle(cornerRadius: MMSpacing.skillBarCornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [MMColors.Semantic.accent, MMColors.Semantic.success],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * animatedRating, height: MMSpacing.skillBarHeight)
                }
            }
            .frame(height: MMSpacing.skillBarHeight)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(name): \(percentage) percent")
        .onAppear {
            withAnimation(MMAnimation.skillBarFill) {
                animatedRating = rating
            }
        }
        .onChange(of: rating) { _, newValue in
            withAnimation(MMAnimation.skillBarFill) {
                animatedRating = newValue
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MMSkillBar(name: "Addition", rating: 0.72)
        MMSkillBar(name: "Subtraction", rating: 0.58)
        MMSkillBar(name: "Multiplication", rating: 0.35)
        MMSkillBar(name: "Division", rating: 0.20)
    }
    .padding()
}
