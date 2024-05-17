import SwiftUI

struct OutOfSpaceMenuView: View {
    var viewModel: SoundSeerViewModel

    var body: some View {
        WarningView("Not enough room for song. Reset width or restart.")

        StandardMenuView(viewModel: viewModel)
    }
}
