import Foundation

struct UITodoItem {
    let id: UUID
    let userId: Int
    let creationDate: Date
    var todoDescription: String
    var isComplited: Bool
}

extension UITodoItem {
    init() {
        id = UUID()
        userId = Int.random(in: 1...100)
        creationDate = .now
        todoDescription = ""
        isComplited = false
    }
}

extension UITodoItem {
    init?(_ todoBD: TodoItem) {
        guard let id = todoBD.id,
              let creationDate = todoBD.creationDate,
              let todo = todoBD.todo else  { return nil }
        
        self.id = id
        self.userId = Int(todoBD.userId)
        self.creationDate = creationDate
        self.isComplited = todoBD.complited
        self.todoDescription = todo
    }
}
