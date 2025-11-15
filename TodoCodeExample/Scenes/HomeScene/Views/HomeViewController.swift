import UIKit

protocol HomeViewPresentable: AnyObject {
//    func showTodos(_ todos: [TodoItem])
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func updateTodo(at indexPath: IndexPath)
    func deleteTodo(at indexPath: IndexPath)
    func insertTodo(at indexPath: IndexPath)
}

//MARK: - HomeViewController
final class HomeViewController: UIViewController {
    private let contentView = HomeView()
    
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

//MARK: Conform to Presentable protocol
extension HomeViewController: HomeViewPresentable {
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func showError(_ message: String) {
        
    }
    
    func updateTodo(at indexPath: IndexPath) {
        
    }
    
    func deleteTodo(at indexPath: IndexPath) {
        
    }
    
    func insertTodo(at indexPath: IndexPath) {
        
    }
}
