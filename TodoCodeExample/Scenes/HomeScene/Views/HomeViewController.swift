import UIKit

protocol HomeViewPresentable: AnyObject {
    func showTodos(_ todos: [UITodoItem])
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
    private let presenter: HomeViewPresenterProtocol
    
    //MARK: - init
    init(presenter: HomeViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle methods
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: Conform to Presentable protocol
extension HomeViewController: HomeViewPresentable {
    func showTodos(_ todos: [UITodoItem]) {
        print("Received \(todos.count) todos")
        // TODO: Обновить UI когда будет готов
    }
    
    func showLoading() {
        print("Loading started")
        // TODO: Показать индикатор загрузки
    }
    
    func hideLoading() {
        print("Loading finished")
        // TODO: Скрыть индикатор загрузки
    }
    
    func showError(_ message: String) {
        print("Error: \(message)")
        // TODO: Показать alert
    }
    
    func updateTodo(at indexPath: IndexPath) {
        print("Update todo at \(indexPath)")
        // TODO: Обновить ячейку таблицы
    }
    
    func deleteTodo(at indexPath: IndexPath) {
        print("Delete todo at \(indexPath)")
        // TODO: Удалить ячейку таблицы
    }
    
    func insertTodo(at indexPath: IndexPath) {
        print("Insert todo at \(indexPath)")
        // TODO: Добавить ячейку таблицы
    }
}
