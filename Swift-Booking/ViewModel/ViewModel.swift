//
//  ViewModel.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import UIKit

class ViewModel {
    
    //MARK: Closures
    let nib = UINib(nibName: "ReastaurentTableCell", bundle: nil)
    var updateLoadingStatus: ((Bool) -> Void)?
   
    //MARK: Computed property
    var isLoading :Bool = false {
        didSet {
            self.updateLoadingStatus?(self.isLoading)
        }
    }
    
    var navigateToRestaurentDetail: (Restaurant) -> () = { _ in }
    
    let api = NetworkManager(apiKey: "NB10SKS20AS30", cookie: "")
    
    //MARK: Method for setup tableview cell
    func registerNib(for tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: "ReastaurentTableCell")
    }
    
    func fetchData(date: String?, time: String?, person: String?, latitude: String, longitude: String, completion : @escaping (RestaurantResponse?) -> ()) {
        isLoading = true
        api.searchTable(date: date ?? "", time: time ?? "", person: person ?? "", latitude: latitude, longitude: longitude) { result in
            self.isLoading = false
            switch result {
            case .success(let data):
                // Handle successful response data
                print("Data: \(data)")
                let convertedData = self.decodeJSONData(data)
                completion(convertedData)
            case .failure(let error):
                // Handle error
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    
    func decodeJSONData(_ data: Data) -> RestaurantResponse?{
        do {
            let decoder = JSONDecoder()
            let myStruct = try decoder.decode(RestaurantResponse.self, from: data)
            return myStruct
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                print("Data corrupted: \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch: \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("Value of type '\(type)' not found: \(context.debugDescription)")
            @unknown default:
                print("Unknown error: \(error.localizedDescription)")
            }
        } catch let error {
            print("Error decoding JSON data: \(error.localizedDescription)")
        }
        return nil
    }
        
}


//ViewModel Validation Extention
extension ViewModel{
    //MARK: Method for present alert when api response failed
    func isFailureResponse(_isError: Bool) -> CustomAlert? {
        return AlertError.responseError.rawValue
    }
    
    //MARK: check if fields are empty
    func checkAlertError(errorType: ErrorType) -> CustomAlert? {
        switch errorType {
        case .dataError :
            return AlertError.responseError.rawValue
        case .locationError :
            return AlertError.locationError.rawValue
        case .dateEmpty :
            return AlertError.dateFiledError.rawValue
        case .personEmpty:
            return AlertError.personFieldError.rawValue
        case .unkownError:
            return AlertError.unknowDataError.rawValue
        }
    }

}




extension ViewModel {
    func fetchRestaurantsFromJSONFile(completion : @escaping (RestaurantResponse?) -> ()) {
        isLoading = true
        if let path = Bundle.main.path(forResource: "RestaurentData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                isLoading = false
                let convertedData = self.decodeJSONData(data)
                completion(convertedData)
            } catch {
                print("Error: \(error)")
                isLoading = false
            }
        }
    }
}
