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
        
        // ✅ Кнопка "Редактировать" справа (три точки как на картинке)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
        
        // ✅ Обработка изменения свитча - автоматическое сохранение
        contentView.onSaveTapped = { [weak self] in
            self?.saveChanges()
        }
        
        contentView.onDeleteTapped = { [weak self] in
            self?.showDeleteConfirmation()
        }
    }
    
    // ✅ Автоматическое сохранение при изменении свитча
    private func saveChanges() {
        currentTodo.isComplited = contentView.completedSwitch.isOn
        presenter.didUpdateTodo(currentTodo, at: todoIndex)
    }
    
    @objc private func editButtonTapped() {
        // Меню с действиями
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Редактировать
        alert.addAction(UIAlertAction(title: "Редактировать", style: .default) { [weak self] _ in
            self?.showEditAlert()
        })
        
        // Поделиться
        alert.addAction(UIAlertAction(title: "Поделиться", style: .default))
        
        // Удалить
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.showDeleteConfirmation()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showEditAlert() {
        let alert = UIAlertController(title: "Редактировать задачу", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = self.currentTodo.todoDescription
            textField.placeholder = "Название задачи"
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let self = self,
                  let textField = alert.textFields?.first,
                  let newTitle = textField.text,
                  !newTitle.isEmpty else { return }
            
            self.currentTodo.todoDescription = newTitle
            self.presenter.didUpdateTodo(self.currentTodo, at: self.todoIndex)
            self.contentView.configure(with: self.currentTodo)
        })
        
        present(alert, animated: true)
    }
    
    private func showDeleteConfirmation() {
        showConfirmationAlert(
            title: "Удалить задачу?",
            message: "Это действие нельзя отменить",
            confirmTitle: "Удалить"
        ) { [weak self] in
            guard let self = self else { return }
            self.presenter.didTapDeleteTodo(at: self.todoIndex)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
