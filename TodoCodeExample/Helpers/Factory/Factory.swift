import Foundation

public protocol Factory {
    associatedtype Context
    associatedtype ViewController
    func build(from context: Context) -> ViewController
}
