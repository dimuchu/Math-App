import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Colors

enum MMColors {
    enum Background {
        static let primary = Color("bg.primary", bundle: nil)
        static let secondary = Color("bg.secondary", bundle: nil)
        static let tertiary = Color("bg.tertiary", bundle: nil)

        // Fallbacks using adaptive colors
        static let primaryAdaptive = Color(light: .white, dark: .black)
        static let secondaryAdaptive = Color(light: Color(hex: 0xF5F5F7), dark: Color(hex: 0x1C1C1E))
        static let tertiaryAdaptive = Color(light: Color(hex: 0xE8E8ED), dark: Color(hex: 0x2C2C2E))
    }

    enum Text {
        static let primary = Color.primary
        static let secondary = Color.secondary
        static let tertiary = Color(light: Color(hex: 0xAEAEB2), dark: Color(hex: 0x636366))
    }

    enum Semantic {
        static let success = Color.green
        static let error = Color.red
        static let accent = Color.accentColor
        static let streak = Color.orange
    }

    enum Numpad {
        static let background = Background.secondaryAdaptive
        static let pressed = Background.tertiaryAdaptive
        static let delete = Color(light: Color(hex: 0xFF3B30), dark: Color(hex: 0xFF453A))
        static let submit = Color(light: Color(hex: 0x007AFF), dark: Color(hex: 0x0A84FF))
    }
}

// MARK: - Typography

enum MMFonts {
    static let display = Font.system(size: 56, weight: .bold, design: .rounded)
    static let numpad = Font.system(size: 28, weight: .medium, design: .rounded)
    static let timer = Font.system(size: 32, weight: .medium, design: .monospaced)
    static let statLarge = Font.system(size: 44, weight: .bold, design: .rounded)
    static let `operator` = Font.system(size: 40, weight: .regular, design: .rounded)
    static let title1 = Font.system(size: 28, weight: .bold, design: .default)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
}

// MARK: - Spacing

enum MMSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48

    static let screenHorizontalPadding: CGFloat = 16
    static let cardCornerRadius: CGFloat = 12
    static let numpadButtonCornerRadius: CGFloat = 12
    static let numpadButtonMinWidth: CGFloat = 72
    static let numpadButtonMinHeight: CGFloat = 52
    static let numpadButtonGap: CGFloat = 8
    static let skillBarHeight: CGFloat = 6
    static let skillBarCornerRadius: CGFloat = 3
}

// MARK: - Animation

enum MMAnimation {
    static let problemTransition: Animation = .easeInOut(duration: 0.25)
    static let correctFeedback: Animation = .easeOut(duration: 0.3)
    static let errorFeedback: Animation = .easeOut(duration: 1.0)
    static let numpadPress: Animation = .easeOut(duration: 0.1)
    static let scoreBounce: Animation = .spring(response: 0.2)
    static let streakPulse: Animation = .linear(duration: 2.0).repeatForever(autoreverses: true)
    static let newRecord: Animation = .spring(response: 0.3)
    static let skillBarFill: Animation = .easeIn(duration: 0.5)

    static let correctFeedbackDuration: TimeInterval = 0.3
    static let errorFeedbackDuration: TimeInterval = 1.0
}

// MARK: - Color Helpers

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }

    init(light: Color, dark: Color) {
        #if os(iOS)
        self.init(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
        #elseif os(macOS)
        self.init(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .vibrantDark]) != nil
                ? NSColor(dark)
                : NSColor(light)
        })
        #else
        self = light
        #endif
    }
}
