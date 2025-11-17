import Foundation

protocol HomeRoutes: AnyObject {
    static func navigateToTodoDetail(
        from presenter: HomeViewPresenterProtocol,
        todo: UITodoItem,
        index: Int
    )
    
    static func navigateToAddTodo(completion: @escaping (UITodoItem) -> Void)
    
    static func shareTodo(_ todo: UITodoItem)
}
