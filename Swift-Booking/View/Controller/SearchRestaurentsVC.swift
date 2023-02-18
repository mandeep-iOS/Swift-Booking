//
//  SearchRestaurentsVC.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import UIKit

class SearchRestaurentsVC: UIViewController {
    
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var serverBtn: UIButton!
    @IBOutlet weak var localBtn: UIButton!
    @IBOutlet weak var dateTimeSelectionTF: DateTimeSelectionTextField!
    @IBOutlet weak var personSelectionTF: PersonSelectionTextField!
    @IBOutlet weak var addressLbl: UILabel!
    private let locationViewModel = LocationViewModel()
    let viewModel = ViewModel()
    var getResponse: [Restaurant] = []
    var latitude = ""
    var longitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.updateLoadingStatus = { [weak self] isShow in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.loadingState(_isShow: isShow)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationViewModel.stopUpdatingLocation()
    }
    
    
    @IBAction func getLocationAction(_ sender: UIButton){
        getLocation()
    }
    
    func getLocation(){
        locationViewModel.getLocation()
        locationViewModel.location = { [weak self] location , address in
            guard let self  = self else {return}
            if address != "" {
                self.addressLbl.text = "Address: \(address), Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)"
                self.latitude = "\(location.coordinate.latitude)"
                self.longitude = "\(location.coordinate.longitude)"
            }
        }
        locationViewModel.error = { error in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton){
        if latitude != "" && longitude != "" {
            if dateTimeSelectionTF.text != "" && personSelectionTF.text != "" {
                let date = dateTimeSelectionTF.datePicker.date
                let formattedDate = date.formattedComponent(.date)
                let formattedTime = date.formattedComponent(.time)
                validateUserInput(date: formattedDate, time: formattedTime, person: personSelectionTF.text, latitude: latitude, longitude: longitude)
                
            }else if dateTimeSelectionTF.text == ""{
                self.showErrorAlert(type: .dateEmpty)
                return
            }else if personSelectionTF.text == "" {
                self.showErrorAlert(type: .personEmpty)
                return
            }
        }else{
            self.showErrorAlert(type: .locationError)
        }
    }
    
    @IBAction func getDataFromLocalFile(_ sender: UIButton){
        callViewModelMethod()
    }
    
}

extension SearchRestaurentsVC {
    
    func validateUserInput(date: String?, time: String?, person: String?, latitude: String, longitude: String){
        if latitude != "" && longitude != "" {
            if date != "" && person != "" {
                fetchData(date: date, time: time, person: person, latitude: latitude, longitude: longitude)
               // callViewModelMethod()
            }else if date == ""{
                self.showErrorAlert(type: .dateEmpty)
                return
            }else if person == "" {
                self.showErrorAlert(type: .personEmpty)
                return
            }
       
        }else{
            self.showErrorAlert(type: .locationError)
        }
    }
    
    //MARK: setup method for start and end date
    func fetchData(date: String?, time: String?, person: String?, latitude: String, longitude: String){
        /*
         /*
          date:2023-02-07
          time:10.30
          person:2
          latitude:53.798407
          longitude:-1.548248
          */
         */
            viewModel.fetchData(date: "2023-02-07", time: "10.30", person: "2", latitude: "53.798407", longitude: "-1.548248") { [weak self] (_resResponse) in
                guard let self = self else {return}
                guard let safeResponse = _resResponse else {return}
                if safeResponse.listed?.count ?? 0 == 0 && safeResponse.status != 200 {
                    self.showErrorAlert(type: .dataError)
                }else{
                    guard let unwrapList = safeResponse.listed else { return  }
                        self.getResponse = unwrapList
                    if self.getResponse.count > 0 {
                        self.navigateToRestaurantListVC(getResponse: self.getResponse)
                    }
                }
            }
    }
    
    func showErrorAlert(type: ErrorType){
        if let alert = self.viewModel.checkAlertError(errorType: type) {
            DispatchQueue.main.async {
                alert.show(on: self)
            }
        }
    }
    
    //MARK: Method for show hide loader
    func loadingState(_isShow: Bool){
        if _isShow {
            Loader.shared.showLoader(self.view)
            self.userIneractionOffWhileLoading(isEnabled: _isShow)
        }else{
            Loader.shared.hideLoader()
            self.userIneractionOffWhileLoading(isEnabled: _isShow)
        }
    }
    
    //MARK: Method for handling UI intreaction based on loader activity
    func userIneractionOffWhileLoading(isEnabled: Bool){
        if isEnabled {
            bgImg.alpha = 0.85
            dateTimeSelectionTF.isUserInteractionEnabled = false
            personSelectionTF.isUserInteractionEnabled = false
            serverBtn.isUserInteractionEnabled = false
            localBtn.isUserInteractionEnabled = false
        }else{
            bgImg.alpha = 1
            dateTimeSelectionTF.isUserInteractionEnabled = true
            personSelectionTF.isUserInteractionEnabled = true
            serverBtn.isUserInteractionEnabled = true
            localBtn.isUserInteractionEnabled = true
        }
    }
    
    func callViewModelMethod(){
        viewModel.fetchRestaurantsFromJSONFile { [weak self] restData in
            guard let self = self else {return}
            guard let unwrapList = restData?.listed else { return  }
            self.getResponse = unwrapList
            self.navigateToRestaurantListVC(getResponse: self.getResponse)
        }
      
    }
    
    func navigateToRestaurantListVC(getResponse: [Restaurant]){
        DispatchQueue.main.async {
            let _: RestaurentListVC? = self.navigateToViewController(withIdentifier: "RestaurentListVC", storyboardName: "Main", data: getResponse)
        }
    }
}
