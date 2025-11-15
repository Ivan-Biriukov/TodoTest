import Foundation
import CoreData

import Foundation

final class HomeViewFactory<Routes: HomeRoutes>: Factory {
    
    struct Context {
        let coreDataContext: NSManagedObjectContext
    }
    
    typealias ViewController = HomeViewController
    
    func build(from context: Context) -> ViewController {
        let storage = CoreDataTasksStorageService(context: context.coreDataContext)
//        let networkService = NetworkService()
        
        let interactor = HomeInteractor(
            storage: storage
//            networkService: networkService
        )
        let presenter = HomeViewPresenter<Routes>()
        
        presenter.interactor = interactor
        interactor.presenter = presenter

        let viewController = HomeViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
