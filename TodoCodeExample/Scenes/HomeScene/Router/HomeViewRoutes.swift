import Foundation

protocol HomeRoutes: AnyObject {
    static func navigateToTodoDetail(todo: UITodoItem)
    static func navigateToAddTodo(completion: @escaping (UITodoItem) -> Void)
}
