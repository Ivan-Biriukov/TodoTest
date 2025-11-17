import Foundation
@testable import TodoCodeExample

final class MockTasksStorage: TasksStorageServicable {
    
    var storedItems: [UITodoItem] = []
    
    func fetchTasks() -> [UITodoItem] {
        storedItems
    }

    func addTask(_ task: UITodoItem) {
        storedItems.append(task)
    }

    func updateTask(_ task: UITodoItem) {
        if let i = storedItems.firstIndex(where: {$0.id == task.id}) {
            storedItems[i] = task
        }
    }

    func deleteTask(id: UUID) {
        storedItems.removeAll { $0.id == id }
    }
}
