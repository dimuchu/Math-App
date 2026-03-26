import SwiftUI

struct MMTimerView: View {
    let remainingSeconds: Int

    private var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private var timerColor: Color {
        remainingSeconds <= 10 ? MMColors.Semantic.error : MMColors.Text.primary
    }

    var body: some View {
        Text(formattedTime)
            .font(MMFonts.timer)
            .foregroundStyle(timerColor)
            .contentTransition(.numericText())
            .animation(.linear(duration: 1.0), value: remainingSeconds)
            .accessibilityLabel("\(remainingSeconds) seconds remaining")
    }
}

#Preview {
    VStack(spacing: 20) {
        MMTimerView(remainingSeconds: 90)
        MMTimerView(remainingSeconds: 8)
    }
}
