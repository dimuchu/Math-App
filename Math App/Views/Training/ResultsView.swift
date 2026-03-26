import SwiftUI

struct ResultsView: View {
    let result: ScoreCalculator.SessionResult
    let mode: TrainingMode
    let onTryAgain: () -> Void
    let onHome: () -> Void

    var body: some View {
        ScrollView {
            MMResultCard(
                result: result,
                mode: mode,
                onTryAgain: onTryAgain,
                onHome: onHome
            )
        }
    }
}
