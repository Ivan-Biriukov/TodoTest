import XCTest
@testable import TodoCodeExample

final class HomePresenterTests: XCTestCase {

    private var presenter: HomeViewPresenter<MockRouter>!
    private var interactor: MockHomeInteractor!
    private var view: MockHomeView!

    override func setUp() {
        super.setUp()
        presenter = HomeViewPresenter<MockRouter>()
        interactor = MockHomeInteractor()
        view = MockHomeView()

        presenter.interactor = interactor
        presenter.view = view
    }

    // GIVEN viewDidLoad called
    // WHEN interactor.fetchTodos
    // THEN view.showLoading is called
    func test_viewDidLoad() {
        presenter.viewDidLoad()

        XCTAssertTrue(view.showLoadingCalled)
        XCTAssertTrue(interactor.fetchCalled)
    }

    // GIVEN presenter has todos
    // WHEN didToggleTodoCompletion
    // THEN interactor.toggleTodoCompletion called with correct index
    func test_toggleTodo() {
        let todo = UITodoItem()
        presenter.didFetchTodos([todo])

        presenter.didToggleTodoCompletion(at: 0)

        XCTAssertEqual(interactor.toggleCalledWith, 0)
    }

    // GIVEN list
    // WHEN didDeleteTodo
    // THEN interactor.deleteTodo index correct
    func test_deleteTodo() {
        let todo = UITodoItem()
        presenter.didFetchTodos([todo])

        presenter.didTapDeleteTodo(at: 0)

        XCTAssertEqual(interactor.deleteCalledWith, 0)
    }

    // GIVEN didFetchTodos
    // THEN view.showTodos called
    func test_didFetchTodos() {
        let todo = UITodoItem()

        presenter.didFetchTodos([todo])

        XCTAssertEqual(view.shownTodos?.count, 1)
    }

    // GIVEN error from interactor
    // THEN view.showError called
    func test_didFail() {
        presenter.didFailToFetchTodos(with: NetworkError.noData)

        XCTAssertEqual(view.errorShown, "Нет данных")
    }
}
