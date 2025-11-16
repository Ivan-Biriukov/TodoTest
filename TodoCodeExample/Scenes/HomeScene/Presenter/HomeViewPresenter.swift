import Foundation

// MARK: - Протокол для View -> Presenter (действия пользователя)
protocol HomeViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectTodo(at index: Int)
    func didToggleTodoCompletion(at index: Int)
    func didTapAddTodo()
    func didTapDeleteTodo(at index: Int)
    func didSearchTodos(with query: String)
    func didUpdateTodo(_ todo: UITodoItem, at index: Int)
    func didTapShare(_ item: UITodoItem)
}

// MARK: - Протокол для Interactor -> Presenter (обратная связь)
protocol HomeInteractorOutput: AnyObject {
    func didFetchTodos(_ todos: [UITodoItem])
    func didFailToFetchTodos(with error: Error)
    func didToggleTodoCompletion(updatedTodo: UITodoItem, at index: Int)
    func didDeleteTodo(at index: Int)
    func didSearchTodos(_ todos: [UITodoItem])
    func didAddTodo(_ todo: UITodoItem)
}

final class HomeViewPresenter<Routes: HomeRoutes> {
    weak var view: HomeViewPresentable?
    var interactor: HomeBusinessLogic?
    
    private var todos: [UITodoItem] = []
    private var filteredTodos: [UITodoItem] = []
    private var isSearching = false
}

// MARK: - View -> Presenter (пользовательские действия)
extension HomeViewPresenter: HomeViewPresenterProtocol {
    func didTapShare(_ item: UITodoItem) {
        Router.shareTodo(item)
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchTodos()
    }

    
    func didSelectTodo(at index: Int) {
        let todosToUse = isSearching ? filteredTodos : todos
        guard index < todosToUse.count else { return }
        
        let todo = todosToUse[index]
        
        // Находим реальный индекс в основном массиве
        guard let mainIndex = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        
        // Передаем self (presenter) в Router
        Routes.navigateToTodoDetail(from: self, todo: todo, index: mainIndex)
    }
    
    func didToggleTodoCompletion(at index: Int) {
        let todosToUse = isSearching ? filteredTodos : todos
        guard index < todosToUse.count else { return }
        
        let todo = todosToUse[index]
        guard let mainIndex = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        
        interactor?.toggleTodoCompletion(at: mainIndex)
    }
    
    func didTapAddTodo() {
        Routes.navigateToAddTodo { [weak self] newTodo in
            self?.interactor?.addTodo(newTodo)
        }
    }
    
    func didTapDeleteTodo(at index: Int) {
        let todosToUse = isSearching ? filteredTodos : todos
        guard index < todosToUse.count else { return }
        
        let todo = todosToUse[index]
        guard let mainIndex = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        
        interactor?.deleteTodo(at: mainIndex)
    }
    
    func didSearchTodos(with query: String) {
        if query.isEmpty {
            isSearching = false
            view?.showTodos(todos)
        } else {
            isSearching = true
            interactor?.searchTodos(query: query)
        }
    }
    
    func didUpdateTodo(_ todo: UITodoItem, at index: Int) {
        interactor?.updateTodo(todo, at: index)
    }
}

// MARK: - Interactor -> Presenter (обратная связь от бизнес-логики)
extension HomeViewPresenter: HomeInteractorOutput {
    
    func didFetchTodos(_ todos: [UITodoItem]) {
        view?.hideLoading()
        self.todos = todos
        view?.showTodos(todos)
    }
    
    func didFailToFetchTodos(with error: Error) {
        view?.hideLoading()
        
        let errorMessage: String
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidURL:
                errorMessage = "Неверный URL"
            case .noData:
                errorMessage = "Нет данных"
            case .decodingError:
                errorMessage = "Ошибка обработки данных"
            case .serverError(let message):
                errorMessage = "Ошибка сервера: \(message)"
            }
        } else {
            errorMessage = error.localizedDescription
        }
        
        view?.showError(errorMessage)
    }
    
    func didToggleTodoCompletion(updatedTodo: UITodoItem, at index: Int) {
        todos[index] = updatedTodo
        
        if isSearching {
            if let filteredIndex = filteredTodos.firstIndex(where: { $0.id == updatedTodo.id }) {
                filteredTodos[filteredIndex] = updatedTodo
            }
        }
        
        let todosToShow = isSearching ? filteredTodos : todos
        view?.showTodos(todosToShow)
    }
    
    func didDeleteTodo(at index: Int) {
        let deletedTodo = todos[index]
        todos.remove(at: index)
        
        if isSearching {
            if let filteredIndex = filteredTodos.firstIndex(where: { $0.id == deletedTodo.id }) {
                filteredTodos.remove(at: filteredIndex)
            }
        }
        
        let todosToShow = isSearching ? filteredTodos : todos
        view?.showTodos(todosToShow)
    }
    
    func didSearchTodos(_ todos: [UITodoItem]) {
        self.filteredTodos = todos
        view?.showTodos(todos)
    }
    
    func didAddTodo(_ todo: UITodoItem) {
        todos.insert(todo, at: 0)
        
        if isSearching {
            view?.showTodos(filteredTodos)
        } else {
            view?.showTodos(todos)
        }
    }
}
