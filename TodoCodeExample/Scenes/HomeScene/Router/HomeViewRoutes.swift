import Foundation

//protocol HomeRoutes: AnyObject {
//    static func navigateToTodoDetail(todo: UITodoItem)
//    static func navigateToAddTodo(completion: @escaping (UITodoItem) -> Void)
//}


protocol HomeRoutes: AnyObject {
    static func navigateToTodoDetail(
        from presenter: HomeViewPresenterProtocol,
        todo: UITodoItem,
        index: Int
    )
    
    static func navigateToAddTodo(completion: @escaping (UITodoItem) -> Void)
}
