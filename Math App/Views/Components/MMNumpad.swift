import SwiftUI

struct MMNumpad: View {
    let onDigit: (Int) -> Void
    let onDelete: () -> Void
    let onToggleMinus: () -> Void
    let onSubmit: () -> Void
    let isSubmitEnabled: Bool

    var body: some View {
        HStack(spacing: MMSpacing.numpadButtonGap) {
            // Digit grid: 3 columns
            VStack(spacing: MMSpacing.numpadButtonGap) {
                HStack(spacing: MMSpacing.numpadButtonGap) {
                    digitButton(1)
                    digitButton(2)
                    digitButton(3)
                }
                HStack(spacing: MMSpacing.numpadButtonGap) {
                    digitButton(4)
                    digitButton(5)
                    digitButton(6)
                }
                HStack(spacing: MMSpacing.numpadButtonGap) {
                    digitButton(7)
                    digitButton(8)
                    digitButton(9)
                }
                HStack(spacing: MMSpacing.numpadButtonGap) {
                    Color.clear
                        .frame(maxWidth: .infinity, minHeight: MMSpacing.numpadButtonMinHeight)
                    digitButton(0)
                    Color.clear
                        .frame(maxWidth: .infinity, minHeight: MMSpacing.numpadButtonMinHeight)
                }
            }

            // Action column
            VStack(spacing: MMSpacing.numpadButtonGap) {
                actionButton(
                    label: { Image(systemName: "delete.left").font(.title3) },
                    color: MMColors.Numpad.delete,
                    textColor: .white
                ) {
                    HapticService.shared.deleteTap()
                    onDelete()
                }
                .accessibilityLabel("Delete")

                actionButton(
                    label: { Text("−").font(MMFonts.numpad) },
                    color: MMColors.Numpad.background,
                    textColor: MMColors.Text.primary
                ) {
                    HapticService.shared.numpadTap()
                    onToggleMinus()
                }
                .accessibilityLabel("Toggle negative")

                actionButton(
                    label: { Image(systemName: "checkmark").font(.title3.weight(.semibold)) },
                    color: isSubmitEnabled ? MMColors.Numpad.submit : MMColors.Numpad.submit.opacity(0.4),
                    textColor: .white
                ) {
                    guard isSubmitEnabled else { return }
                    HapticService.shared.numpadTap()
                    onSubmit()
                }
                .accessibilityLabel("Submit answer")
                .disabled(!isSubmitEnabled)
            }
            .frame(width: MMSpacing.numpadButtonMinWidth)
        }
        .padding(.horizontal, MMSpacing.lg)
    }

    private func digitButton(_ digit: Int) -> some View {
        NumpadButton(
            color: MMColors.Numpad.background,
            textColor: MMColors.Text.primary
        ) {
            HapticService.shared.numpadTap()
            onDigit(digit)
        } label: {
            Text("\(digit)")
                .font(MMFonts.numpad)
        }
        .accessibilityLabel("digit \(digit)")
    }

    private func actionButton<Label: View>(
        @ViewBuilder label: @escaping () -> Label,
        color: Color,
        textColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        NumpadButton(color: color, textColor: textColor, action: action, label: label)
    }
}

private struct NumpadButton<Label: View>: View {
    let color: Color
    let textColor: Color
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    @State private var isPressed = false

    var body: some View {
        label()
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, minHeight: MMSpacing.numpadButtonMinHeight)
            .background(color, in: RoundedRectangle(cornerRadius: MMSpacing.numpadButtonCornerRadius))
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(MMAnimation.numpadPress, value: isPressed)
            .onTapGesture {
                isPressed = true
                action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
    }
}

#Preview {
    MMNumpad(
        onDigit: { _ in },
        onDelete: {},
        onToggleMinus: {},
        onSubmit: {},
        isSubmitEnabled: true
    )
}
