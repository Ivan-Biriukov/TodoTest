import Foundation
@testable import TodoCodeExample

final class MockHomeView: HomeViewPresentable {

    var showLoadingCalled = false
    var hideLoadingCalled = false
    var shownTodos: [UITodoItem]?
    var errorShown: String?

    func showTodos(_ todos: [UITodoItem]) {
        shownTodos = todos
    }

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }

    func showError(_ message: String) {
        errorShown = message
    }
}
