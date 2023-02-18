//
//  CommonExtension.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import UIKit

extension UIView {
    func setCornerRadius(radius: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
}
extension UIImageView {
    func loadImageFromURL(_ url: URL) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        dataTask.resume()
    }
}

extension Date {
    enum DateComponent {
        case date
        case time
    }
    
    func formattedComponent(_ component: DateComponent) -> String {
        let dateFormatter = DateFormatter()
        
        switch component {
        case .date:
            dateFormatter.dateFormat = "yyyy-MM-dd"
        case .time:
            dateFormatter.dateFormat = "HH:mm"
        }
        
        return dateFormatter.string(from: self)
    }
}

protocol DataPassing {
    var data: Any? { get set }
}

extension UIViewController {
    func navigateToViewController<T: UIViewController>(withIdentifier identifier: String, storyboardName: String, data: Any? = nil) -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            if let data = data {
                if var viewControllerWithData = viewController as? DataPassing {
                    viewControllerWithData.data = data
                }
            }
            self.navigationController?.pushViewController(viewController, animated: true)
            return viewController
        }
        return nil
    }
}
