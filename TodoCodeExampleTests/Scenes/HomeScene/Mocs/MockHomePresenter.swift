import Foundation
@testable import TodoCodeExample

final class MockHomePresenter: HomeInteractorOutput {

    var didFetchTodosCalledWith: [UITodoItem]?
    var didFailToFetchTodosCalled: Error?
    var didToggleTodoCompletionCalled = false
    var didDeleteCalled = false

    var onFail: ((Error)->Void)?
    var onDidFetchTodos: (([UITodoItem])->Void)?
    var onToggle: ((UITodoItem, Int)->Void)?
    var onDelete: ((Int)->Void)?
    var onSearch: (([UITodoItem])->Void)?

    func didFetchTodos(_ todos: [UITodoItem]) {
        didFetchTodosCalledWith = todos
        onDidFetchTodos?(todos)
    }

    func didFailToFetchTodos(with error: Error) {
        didFailToFetchTodosCalled = error
        onFail?(error)
    }

    func didToggleTodoCompletion(updatedTodo: UITodoItem, at index: Int) {
        didToggleTodoCompletionCalled = true
        onToggle?(updatedTodo, index)
    }

    func didDeleteTodo(at index: Int) {
        didDeleteCalled = true
        onDelete?(index)
    }

    func didSearchTodos(_ todos: [UITodoItem]) {
        onSearch?(todos)
    }

    func didAddTodo(_ todo: UITodoItem) {}
}
