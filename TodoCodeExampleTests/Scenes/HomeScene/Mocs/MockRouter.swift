import Foundation
@testable import TodoCodeExample

final class MockRouter: HomeRoutes {
    
    static var lastTodoDetail: UITodoItem?
    static var lastIndex: Int?
    static var lastSharedTodo: UITodoItem?
    static var addTodoCompletion: ((UITodoItem) -> Void)?

    static func navigateToTodoDetail(
        from presenter: HomeViewPresenterProtocol,
        todo: UITodoItem,
        index: Int
    ) {
        lastTodoDetail = todo
        lastIndex = index
    }

    static func shareTodo(_ todo: UITodoItem) {
        lastSharedTodo = todo
    }

    static func navigateToAddTodo(completion: @escaping (UITodoItem) -> Void) {
        addTodoCompletion = completion
    }
}
