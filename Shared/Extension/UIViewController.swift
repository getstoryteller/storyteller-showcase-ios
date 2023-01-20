import UIKit

extension UIViewController {
    func handle(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "An error occured",
                message: error.localizedDescription,
                preferredStyle: .alert)

            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default))

            self.present(alert, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)

        present(controller, animated: true, completion: nil)
    }
}
