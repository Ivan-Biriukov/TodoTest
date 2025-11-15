import Foundation
import CoreData

protocol TasksStorageServicable {
    func fetchTasks() -> [UITodoItem]
    func addTask(_ task: UITodoItem)
    func updateTask(_ task: UITodoItem)
    func deleteTask(id: UUID)
}

final class CoreDataTasksStorageService: TasksStorageServicable {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchTasks() -> [UITodoItem] {
        let request = TodoItem.fetchRequest()
        guard let result = try? context.fetch(request) else {
            return []
        }
        
        return result.compactMap { UITodoItem($0) }
    }

    func addTask(_ task: UITodoItem) {
        let obj = TodoItem(context: context)
        obj.id = task.id
        obj.userId = Int16(task.userId)
        obj.creationDate = task.creationDate
        obj.complited = task.isComplited
        obj.todo = task.todoDescription

        try? context.save()
    }

    func updateTask(_ task: UITodoItem) {
        let request = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        if let obj = try? context.fetch(request).first {
            obj.userId = Int16(task.userId)
            obj.creationDate = task.creationDate
            obj.complited = task.isComplited
            obj.todo = task.todoDescription
            
            try? context.save()
        }
    }

    func deleteTask(id: UUID) {
        let request = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        if let obj = try? context.fetch(request).first {
            context.delete(obj)
            try? context.save()
        }
    }
}
