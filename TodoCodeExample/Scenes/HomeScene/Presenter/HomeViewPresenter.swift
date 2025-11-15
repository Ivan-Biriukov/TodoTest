import Foundation

protocol HomeViewPresenterProtocol {
    
}

final class HomeViewPresenter {
    weak var view: HomeViewPresentable?
    var interactor: HomeBusinessLogic?
    var router: HomeRoutes?
}

extension HomeViewPresenter: HomeViewPresenterProtocol {
    
}
