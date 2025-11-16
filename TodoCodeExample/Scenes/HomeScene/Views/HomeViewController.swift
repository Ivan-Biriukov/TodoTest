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
    
    private enum Section: Int, Hashable, Sendable {
        case main = 0
    }
    
    private var todos: [UITodoItem] = []
    
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
        setupNavigationBar()
        setupTableView()
        setupCallbacks()
        
        presenter.viewDidLoad()
    }
}

//MARK: - Private Methods
private extension HomeViewController {
    private func setupNavigationBar() {
        // Скрываем стандартный navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTableView() {
        contentView.tableView.delegate = self
    }
    
    private func setupCallbacks() {
        // Кнопка добавления -> presenter
        contentView.onAddButtonTapped = { [weak self] in
            self?.presenter.didTapAddTodo()
        }
        
        // Поиск -> presenter
        contentView.onSearchTextChanged = { [weak self] query in
            self?.presenter.didSearchTodos(with: query)
        }
    }
}

//MARK: Conform to Presentable protocol
extension HomeViewController: HomeViewPresentable {
    func showTodos(_ todos: [UITodoItem]) {
        self.todos = todos
        contentView.tableView.reloadData()
        contentView.showEmptyState(todos.isEmpty)
    }
    
    func showLoading() {
        contentView.showLoading()
       }
    
    func hideLoading() {
          contentView.hideLoading()
      }
    
    func showError(_ message: String) {
        showAlert(message: message)
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

//MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        
        cell.onCheckmarkTapped = { [weak self] in
            self?.presenter.didToggleTodoCompletion(at: indexPath.row)
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectTodo(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Действие "Редактировать"
        let editAction = UIContextualAction(style: .normal, title: "Редактировать") { [weak self] _, _, completion in
            self?.presenter.didSelectTodo(at: indexPath.row)
            completion(true)
        }
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = .systemBlue
        
        // Действие "Удалить"
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            self?.showConfirmationAlert(
                title: "Удалить задачу?",
                message: "Это действие нельзя отменить",
                confirmTitle: "Удалить"
            ) {
                self?.presenter.didTapDeleteTodo(at: indexPath.row)
            }
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self = self, indexPath.row < self.todos.count else { return nil }
            
            let todo = self.todos[indexPath.row]
            
            // Действие "Выполнено/Не выполнено"
            let toggleTitle = todo.isComplited ? "Отметить как невыполненное" : "Отметить как выполненное"
            let toggleImage = todo.isComplited ? "circle" : "checkmark.circle.fill"
            
            let toggleAction = UIAction(
                title: toggleTitle,
                image: UIImage(systemName: toggleImage)
            ) { _ in
                self.presenter.didToggleTodoCompletion(at: indexPath.row)
            }
            
            // Действие "Редактировать"
            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "pencil")
            ) { _ in
                self.presenter.didSelectTodo(at: indexPath.row)
            }
            
            // Действие "Удалить"
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.showConfirmationAlert(
                    title: "Удалить задачу?",
                    message: "Это действие нельзя отменить",
                    confirmTitle: "Удалить"
                ) {
                    self.presenter.didTapDeleteTodo(at: indexPath.row)
                }
            }
            
            return UIMenu(title: "", children: [toggleAction, editAction, deleteAction])
        }
    }
}
