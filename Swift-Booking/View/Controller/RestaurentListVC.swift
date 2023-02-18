//
//  RestaurentListVC.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import UIKit
import CoreLocation

class RestaurentListVC: UIViewController, DataPassing {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let locationViewModel = LocationViewModel()
    let viewModel = ViewModel()
    var getResponse: [Restaurant] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var data: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = data as? [Restaurant] {
            getResponse = data
        }
        setupTableViewCell()
    }
    
    func setupTableViewCell(){
        let nib = UINib(nibName: "ReastaurentTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReastaurentTableCell")
    }
}

extension RestaurentListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let restaurentCell = tableView.dequeueReusableCell(withIdentifier: "ReastaurentTableCell", for: indexPath) as? ReastaurentTableCell else { return UITableViewCell() }
        if getResponse.count > 0 {
            restaurentCell.frame = tableView.bounds
            restaurentCell.layoutIfNeeded()
            restaurentCell.selectionStyle = .none
            restaurentCell.setCellData(_data: getResponse[indexPath.row])
        }
        return restaurentCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if getResponse.count > 0 {
            let indexData = getResponse[indexPath.row]
            navigateToRestaurantListVC(_indexData: indexData)
        }
    }
    
    func navigateToRestaurantListVC(_indexData: Restaurant){
        DispatchQueue.main.async {
            let _: RestaurantDetailVC? = self.navigateToViewController(withIdentifier: "RestaurantDetailVC", storyboardName: "Main", data: _indexData)
        }
    }
    
}

