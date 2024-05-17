import Combine
import SwiftUI

final class KeyboardResponder: ObservableObject {
    @Published var isVisible: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { _ in self.isVisible = true }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { _ in self.isVisible = false }
            .store(in: &cancellables)
    }
}
