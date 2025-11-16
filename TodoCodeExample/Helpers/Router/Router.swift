import UIKit
import CoreData

final class Router {
    private static let navigationController = UINavigationController()
    private init() {}
}

extension Router {
    static func startRouting() -> UINavigationController {
        return navigationController
    }
    
    static func performRoute<F>(
        factory: F,
        context: F.Context,
        animated: Bool = true
    ) where F: Factory, F.ViewController: UIViewController {
        let viewController = factory.build(from: context)
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    static func performPopUpRoute<F>(
        factory: F,
        context: F.Context,
        animated: Bool = true
    ) where F: Factory, F.ViewController: UIViewController {
        let vc = factory.build(from: context)
        vc.modalPresentationStyle = .popover
        
        navigationController.present(vc, animated: true)
    }
}

extension Router {
    static func homeScreen(coreDataContext: NSManagedObjectContext) {
        let ctx = HomeViewFactory<Self>.Context(coreDataContext: coreDataContext)
        performRoute(factory: HomeViewFactory<Self>(), context: ctx)
    }
}

//MARK: - Home View Routes
extension Router: HomeRoutes {
    
    static func navigateToTodoDetail(
        from presenter: HomeViewPresenterProtocol,
        todo: UITodoItem,
        index: Int
    ) {
        let detailVC = DetailViewController(
            presenter: presenter,
            todo: todo,
            index: index
        )
        
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    static func navigateToAddTodo(completion: @escaping (UITodoItem) -> Void) {
        let alert = UIAlertController(
            title: "Новая задача",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Название задачи"
            textField.autocapitalizationType = .sentences
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            guard let titleField = alert.textFields?[0],
                  let title = titleField.text,
                  !title.isEmpty else {
                return
            }
            
            var newTodo = UITodoItem()
            newTodo.todoDescription = title
            
            completion(newTodo)
        }
        
        alert.addAction(addAction)
        
        navigationController.visibleViewController?.present(alert, animated: true)
    }
}
//extension Router: HomeRoutes {
//    static func navigateToTodoDetail(todo: UITodoItem) {
//        // TODO: Реализовать когда будет готов DetailFactory
//        print("Navigate to detail for todo: \(todo.todoDescription)")
//        
//        // Пока заглушка, потом заменим на:
//        // let context = DetailFactory.Context(todo: todo)
//        // performRoute(factory: DetailFactory(), context: context)
//    }
//    
//    static func navigateToAddTodo(completion: @escaping (UITodoItem) -> Void) {
//        // TODO: Реализовать когда будет готов AddTodoFactory
//        print("Navigate to add todo")
//        
//        // Пока заглушка, потом заменим на:
//        // let context = AddTodoFactory.Context(completion: completion)
//        // performPopUpRoute(factory: AddTodoFactory(), context: context)
//    }
//}
