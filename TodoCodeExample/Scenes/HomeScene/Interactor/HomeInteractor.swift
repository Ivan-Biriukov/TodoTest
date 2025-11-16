import Foundation

protocol HomeBusinessLogic {
    func fetchTodos()
    func toggleTodoCompletion(at index: Int)
    func deleteTodo(at index: Int)
    func searchTodos(query: String)
    func addTodo(_ todo: UITodoItem)
    func updateTodo(_ todo: UITodoItem, at index: Int)
}

final class HomeInteractor {
    private let storage: TasksStorageServicable
    private let networkService: NetworkServiceProtocol
    weak var presenter: HomeInteractorOutput?
    
    private var allTodos: [UITodoItem] = []
    
    init(storage: TasksStorageServicable, networkService: NetworkServiceProtocol) {
        self.storage = storage
        self.networkService = networkService
    }
}

//MARK: - Interface methods
extension HomeInteractor: HomeBusinessLogic {
    func fetchTodos() {
        let localTodos = storage.fetchTasks()
        guard let presenter else {return}
        
        switch localTodos.isEmpty {
        case true:
            loadTodosFromAPI()
        case false:
            self.allTodos = localTodos
            presenter.didFetchTodos(localTodos)
        }
    }
    
    func toggleTodoCompletion(at index: Int) {
        guard index < allTodos.count else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            var todo = self.allTodos[index]
            todo.isComplited.toggle()
            self.allTodos[index] = todo
            
            self.storage.updateTask(todo)
            
            DispatchQueue.main.async {
                self.presenter?.didToggleTodoCompletion(updatedTodo: todo, at: index)
            }
        }
    }
    
    func deleteTodo(at index: Int) {
        guard index < allTodos.count else { return }
        
        let todoToDelete = allTodos[index]
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.storage.deleteTask(id: todoToDelete.id)
            
            self.allTodos.remove(at: index)
            
            DispatchQueue.main.async {
                self.presenter?.didDeleteTodo(at: index)
            }
        }
    }
    
    func searchTodos(query: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let filtered: [UITodoItem]
            
            if query.isEmpty {
                filtered = self.allTodos
            } else {
                filtered = self.allTodos.filter {
                    $0.todoDescription.lowercased().contains(query.lowercased())
                }
            }
            
            DispatchQueue.main.async {
                self.presenter?.didSearchTodos(filtered)
            }
        }
    }
    
    func addTodo(_ todo: UITodoItem) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.storage.addTask(todo)
            
            self.allTodos.insert(todo, at: 0)
            
            DispatchQueue.main.async {
                self.presenter?.didAddTodo(todo)
            }
        }
    }
    
    func updateTodo(_ todo: UITodoItem, at index: Int) {
        guard index < allTodos.count else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.allTodos[index] = todo
            self.storage.updateTask(todo)
            
            DispatchQueue.main.async {
                self.presenter?.didToggleTodoCompletion(updatedTodo: todo, at: index)
            }
        }
    }
}

//MARK: - Private methods
private extension HomeInteractor {
    func loadTodosFromAPI() {
        networkService.fetchTodos { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let apiTodos):
                let uiTodos = apiTodos.map { UITodoItem(from: $0) }
                self.allTodos = uiTodos
                
                DispatchQueue.global(qos: .background).async {
                    uiTodos.forEach { self.storage.addTask($0) }
                }
                
                DispatchQueue.main.async {
                    self.presenter?.didFetchTodos(uiTodos)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchTodos(with: error)
                }
            }
        }
    }
}
