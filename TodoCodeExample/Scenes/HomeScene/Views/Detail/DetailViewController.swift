import UIKit

final class DetailViewController: UIViewController {
    
    private let contentView = DetailView()
    private let presenter: HomeViewPresenterProtocol
    private var currentTodo: UITodoItem
    private let todoIndex: Int
    
    init(presenter: HomeViewPresenterProtocol, todo: UITodoItem, index: Int) {
        self.presenter = presenter
        self.currentTodo = todo
        self.todoIndex = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        contentView.configure(with: currentTodo)
    }
    
    private func setupUI() {
        title = ""
        
        contentView.onSaveTapped = { [weak self] in
            self?.saveChanges()
        }
    }
    
    private func saveChanges() {
        currentTodo.isComplited = contentView.completedSwitch.isOn
        presenter.didUpdateTodo(currentTodo, at: todoIndex)
    }
}
