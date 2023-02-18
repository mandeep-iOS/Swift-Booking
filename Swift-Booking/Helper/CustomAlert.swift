//
//  CustomAlert.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//

import UIKit
enum ErrorType {
    case dataError
    case locationError
    case dateEmpty
    case personEmpty
    case unkownError
}

//MARK: Custom Class Alert for based on validation of rquired alert in function
struct CustomAlert: RawRepresentable {
    let title: String
    let message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    typealias RawValue = CustomAlert
    
    init?(rawValue: CustomAlert) {
        self = rawValue
    }
    
    var rawValue: CustomAlert {
        return self
    }
    
    func show(on viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: Enum Alert Error with CustomAlert Class predefined title and message
enum AlertError {
    case responseError
    case locationError
    case dateFiledError
    case personFieldError
    case unknowDataError
    
    var rawValue: CustomAlert {
        switch self {
        case .responseError:
            return CustomAlert(title: "Data Failure", message: "Something went wrong. please try again.")
        case .locationError:
            return CustomAlert(title: "Error", message: "Location needed for fetch server data. for fetch location tap on location icon.")
        case .dateFiledError:
            return CustomAlert(title: "Empty", message: "Please select date and time from the date field.")
        case .personFieldError:
            return CustomAlert(title: "Empty", message: "Please select person count from the person field.")
        case .unknowDataError:
            return CustomAlert(title: "Unknown Error", message: "")
        }
    }
}
