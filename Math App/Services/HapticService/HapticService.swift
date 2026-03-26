import Foundation

#if os(iOS)
import UIKit
#endif

@MainActor
final class HapticService {
    static let shared = HapticService()

    private var isEnabled: Bool {
        AppSettings.shared.hapticsEnabled
    }

    private init() {}

    func numpadTap() {
        guard isEnabled else { return }
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }

    func correctAnswer() {
        guard isEnabled else { return }
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }

    func wrongAnswer() {
        guard isEnabled else { return }
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        #endif
    }

    func newRecord() {
        guard isEnabled else { return }
        #if os(iOS)
        let heavy = UIImpactFeedbackGenerator(style: .heavy)
        heavy.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let success = UINotificationFeedbackGenerator()
            success.notificationOccurred(.success)
        }
        #endif
    }

    func timerWarning() {
        guard isEnabled else { return }
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        #endif
    }

    func deleteTap() {
        guard isEnabled else { return }
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        #endif
    }
}
