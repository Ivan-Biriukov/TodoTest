import Foundation

struct UITodoItem: Codable, Sendable {
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

extension UITodoItem: Equatable {
    static func == (lhs: UITodoItem, rhs: UITodoItem) -> Bool {
        return lhs.id == rhs.id &&
        lhs.userId == rhs.userId &&
        lhs.creationDate == rhs.creationDate &&
        lhs.todoDescription == rhs.todoDescription &&
        lhs.isComplited == rhs.isComplited
    }
}

extension UITodoItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(userId)
        hasher.combine(creationDate)
        hasher.combine(todoDescription)
        hasher.combine(isComplited)
    }
}

extension UITodoItem {
    init(from apiItem: TodoAPIItem) {
        self.id = UUID()
        self.userId = apiItem.userId
        self.creationDate = Date()
        self.todoDescription = apiItem.todo
        self.isComplited = apiItem.completed
    }
}
