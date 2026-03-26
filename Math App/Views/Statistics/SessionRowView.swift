import SwiftUI

struct SessionRowView: View {
    let session: Session

    private var dateText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: session.startDate, relativeTo: .now)
    }

    private var modeText: String {
        session.mode.displayName
    }

    private var resultText: String {
        switch session.mode {
        case .practice:
            "\(Int(session.accuracy * 100))%"
        case .timeAttack:
            "\(session.totalProblems) solved"
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: MMSpacing.xs) {
                Text(modeText)
                    .font(MMFonts.body)
                    .foregroundStyle(MMColors.Text.primary)
                Text(dateText)
                    .font(MMFonts.caption)
                    .foregroundStyle(MMColors.Text.secondary)
            }

            Spacer()

            Text(resultText)
                .font(MMFonts.body.weight(.medium))
                .foregroundStyle(MMColors.Text.primary)
        }
        .padding(.horizontal, MMSpacing.lg)
        .padding(.vertical, MMSpacing.md)
    }
}
