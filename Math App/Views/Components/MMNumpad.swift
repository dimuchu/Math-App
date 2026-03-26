import SwiftUI

struct MMNumpad: View {
    let onDigit: (Int) -> Void
    let onDelete: () -> Void
    let onToggleMinus: () -> Void
    let onSubmit: () -> Void
    let isSubmitEnabled: Bool

    var body: some View {
        VStack(spacing: MMSpacing.numpadButtonGap) {
            // Row 1: [1] [2] [3] [Delete]
            HStack(spacing: MMSpacing.numpadButtonGap) {
                digitButton(1)
                digitButton(2)
                digitButton(3)
                actionButton(
                    label: { Image(systemName: "delete.left").font(.title3) },
                    color: MMColors.Numpad.delete,
                    textColor: .white
                ) {
                    HapticService.shared.deleteTap()
                    onDelete()
                }
                .accessibilityLabel("Delete")
            }

            // Row 2: [4] [5] [6] [Minus]
            HStack(spacing: MMSpacing.numpadButtonGap) {
                digitButton(4)
                digitButton(5)
                digitButton(6)
                actionButton(
                    label: { Text("−").font(MMFonts.numpad) },
                    color: MMColors.Numpad.background,
                    textColor: MMColors.Text.primary
                ) {
                    HapticService.shared.numpadTap()
                    onToggleMinus()
                }
                .accessibilityLabel("Toggle negative")
            }

            // Row 3: [7] [8] [9] [Submit]
            HStack(spacing: MMSpacing.numpadButtonGap) {
                digitButton(7)
                digitButton(8)
                digitButton(9)
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

            // Row 4: [0 — spans 2 columns] + empty space
            HStack(spacing: MMSpacing.numpadButtonGap) {
                digitButton(0)
                Spacer()
                    .frame(maxWidth: .infinity)
            }
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
