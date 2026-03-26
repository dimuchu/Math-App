import SwiftUI

struct DiagnosticResultsView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: MMSpacing.xxl) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(MMColors.Semantic.success)

            Text("Diagnostic Complete")
                .font(MMFonts.title1)

            // Skill results by operation
            VStack(spacing: MMSpacing.md) {
                Text("Your Skills")
                    .font(MMFonts.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(viewModel.operationResults, id: \.operation) { result in
                    MMSkillBar(name: result.operation.displayName, rating: result.rating)
                }
            }
            .padding(.horizontal, MMSpacing.lg)

            // Weak area highlight
            if let weakest = viewModel.weakestSkill {
                Text("Focus area: \(weakest.operation.displayName)")
                    .font(MMFonts.callout)
                    .foregroundStyle(MMColors.Semantic.error)
            }

            if let strongest = viewModel.strongestSkill {
                Text("Strongest: \(strongest.operation.displayName)")
                    .font(MMFonts.callout)
                    .foregroundStyle(MMColors.Semantic.success)
            }

            Spacer()

            Button {
                viewModel.complete()
            } label: {
                Text("Start Training")
                    .font(MMFonts.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, MMSpacing.md)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, MMSpacing.xl)
            .padding(.bottom, MMSpacing.xxl)
        }
    }
}
