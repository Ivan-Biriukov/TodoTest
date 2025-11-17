import Foundation
@testable import TodoCodeExample

final class MockHomeInteractor: HomeBusinessLogic {
    
    var fetchCalled = false
    var toggleCalledWith: Int?
    var deleteCalledWith: Int?

    func fetchTodos() {
        fetchCalled = true
    }

    func toggleTodoCompletion(at index: Int) {
        toggleCalledWith = index
    }

    func deleteTodo(at index: Int) {
        deleteCalledWith = index
    }

    func searchTodos(query: String) {}

    func addTodo(_ todo: UITodoItem) {}

    func updateTodo(_ todo: UITodoItem, at index: Int) {}
}
