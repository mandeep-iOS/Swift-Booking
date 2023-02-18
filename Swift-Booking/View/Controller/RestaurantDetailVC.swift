//
//  RestaurantDetailVC.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import UIKit

class RestaurantDetailVC: UIViewController, DataPassing {
    
    @IBOutlet weak var restaurantImg: UIImageView!
    @IBOutlet weak var resNameLbl: UILabel!
    @IBOutlet weak var resTypeLbl: UILabel!
    @IBOutlet weak var resDescLbl: UILabel!
    @IBOutlet weak var resRatingLbl: UILabel!
    @IBOutlet weak var resAddressLbl: UILabel!
    @IBOutlet weak var resTimeAvailbleLbl: UILabel!
    @IBOutlet weak var resSeatAvailbleLbl: UILabel!
    @IBOutlet weak var resServiceProviderLbl: UILabel!
    @IBOutlet weak var resPriceLbl: UILabel!
    
    var data: Any?
    var restaurantData: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = data as? Restaurant {
            restaurantData = data
        }
        guard let resData = restaurantData else {return}
        updateDataOnUI(_data: resData)
    }
    
    func updateDataOnUI(_data: Restaurant){
        if let imageURL = URL(string: _data.image ?? "") {
            restaurantImg.loadImageFromURL(imageURL)
        }
        resNameLbl.text = _data.businessName
        resTypeLbl.text = _data.restaurantType?.first?.name ?? "NA"
        resDescLbl.text = _data.description
        resRatingLbl.text = (_data.rating ?? "0") + "/" + "5"
        resAddressLbl.text = _data.address ?? ""
        if let countTime = _data.timeAvailable, countTime.count > 0 {
            resTimeAvailbleLbl.text = "Yes"
        }else{
            resTimeAvailbleLbl.text = "No"
        }
        if _data.seatAvailable == "na"{
            resTimeAvailbleLbl.text = "Full"
        }else{
            resTimeAvailbleLbl.text = "Available"
        }
      
        if let price = _data.price {
            switch price {
            case .integer(let value):
                if value == 0 {
                    resPriceLbl.text = "0.0"
                }else{
                    resPriceLbl.text = String(value)
                }
                
            case .string(let value):
                resPriceLbl.text = value
            }
        } else {
            resPriceLbl.text = "0.0"
        }

        
    }

}
