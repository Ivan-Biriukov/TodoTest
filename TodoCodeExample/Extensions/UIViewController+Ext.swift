import UIKit

extension UIViewController {
    /// Показать простой alert с сообщением
    func showAlert(title: String = "Ошибка", message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    /// Показать alert с подтверждением
    func showConfirmationAlert(
        title: String,
        message: String,
        confirmTitle: String = "Подтвердить",
        cancelTitle: String = "Отмена",
        confirmHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: confirmTitle, style: .destructive) { _ in
            confirmHandler()
        })
        
        present(alert, animated: true)
    }
}
