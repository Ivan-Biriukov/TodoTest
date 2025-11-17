import XCTest
@testable import TodoCodeExample

final class HomeInteractorTests: XCTestCase {

    private var storage: MockTasksStorage!
    private var network: MockNetworkService!
    private var presenter: MockHomePresenter!
    private var interactor: HomeInteractor!
    
    override func setUp() {
        super.setUp()
        storage = MockTasksStorage()
        network = MockNetworkService()
        presenter = MockHomePresenter()
        interactor = HomeInteractor(storage: storage, networkService: network)
        interactor.presenter = presenter
    }
    
    override func tearDown() {
        storage = nil
        network = nil
        presenter = nil
        interactor = nil
        super.tearDown()
    }
    
    // GIVEN local storage has items
    // WHEN fetchTodos()
    // THEN presenter.didFetchTodos is called with local items
    func test_fetchTodos_localNotEmpty() {
        let item = UITodoItem(id: UUID(), userId: 1, creationDate: .now, todoDescription: "Test", isComplited: false)
        storage.storedItems = [item]
        
        interactor.fetchTodos()
        
        XCTAssertEqual(presenter.didFetchTodosCalledWith?.count, 1)
        XCTAssertEqual(presenter.didFetchTodosCalledWith?.first?.todoDescription, "Test")
    }

    // GIVEN local storage empty, API returns items
    // WHEN fetchTodos()
    // THEN presenter.didFetchTodos is called with API items
    func test_fetchTodos_loadFromAPI() {
        storage.storedItems = []
        network.mockResult = .success([TodoAPIItem(id: 1, todo: "A", completed: false, userId: 10)])
        
        let expectation = XCTestExpectation(description: "API callback")

        presenter.onDidFetchTodos = { todos in
            XCTAssertEqual(todos.count, 1)
            XCTAssertEqual(todos.first?.todoDescription, "A")
            expectation.fulfill()
        }

        interactor.fetchTodos()

        wait(for: [expectation], timeout: 1)
    }
    
    // GIVEN API error
    // WHEN fetchTodos()
    // THEN presenter.didFailToFetchTodos is called
    func test_fetchTodos_apiError() {
        storage.storedItems = []
        network.mockResult = .failure(.noData)
        
        let expectation = XCTestExpectation(description: "Error callback")

        presenter.onFail = { error in
            XCTAssertTrue(error is NetworkError)
            expectation.fulfill()
        }

        interactor.fetchTodos()

        wait(for: [expectation], timeout: 1)
    }
    
    // GIVEN todo exists
    // WHEN toggleTodoCompletion
    // THEN presenter.didToggleTodoCompletion is called with updated item
    func test_toggleTodoCompletion() {
        let id = UUID()
        let todo = UITodoItem(id: id, userId: 1, creationDate: .now, todoDescription: "T", isComplited: false)
        storage.storedItems = [todo]
        interactor.fetchTodos()

        let expectation = XCTestExpectation(description: "toggle callback")

        presenter.onToggle = { updated, index in
            XCTAssertTrue(updated.isComplited)
            XCTAssertEqual(index, 0)
            expectation.fulfill()
        }

        interactor.toggleTodoCompletion(at: 0)

        wait(for: [expectation], timeout: 1)
    }

    // GIVEN list has item
    // WHEN deleteTodo
    // THEN presenter.didDeleteTodo called
    func test_deleteTodo() {
        let id = UUID()
        let todo = UITodoItem(id: id, userId: 1, creationDate: .now, todoDescription: "T", isComplited: false)
        storage.storedItems = [todo]
        interactor.fetchTodos()

        let expectation = XCTestExpectation(description: "delete callback")

        presenter.onDelete = { index in
            XCTAssertEqual(index, 0)
            expectation.fulfill()
        }

        interactor.deleteTodo(at: 0)

        wait(for: [expectation], timeout: 1)
    }

    // GIVEN two todos
    // WHEN searchTodos("a")
    // THEN presenter.didSearchTodos returns filtered items
    func test_searchTodos() {
        let t1 = UITodoItem(id: UUID(), userId: 1, creationDate: .now, todoDescription: "apple", isComplited: false)
        let t2 = UITodoItem(id: UUID(), userId: 1, creationDate: .now, todoDescription: "banana", isComplited: false)
        storage.storedItems = [t1, t2]
        interactor.fetchTodos()

        let expectation = XCTestExpectation(description: "search callback")

        presenter.onSearch = { result in
            XCTAssertEqual(result.count, 2)
            expectation.fulfill()
        }

        interactor.searchTodos(query: "a")

        wait(for: [expectation], timeout: 1)
    }
}
