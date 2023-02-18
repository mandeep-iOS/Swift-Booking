//
//  ReastaurentTableCell.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//

import UIKit

class ReastaurentTableCell: UITableViewCell {
    var getTimeFromTimeArr: (TimeAvailable) -> () = { _ in }
    @IBOutlet weak var restaurentImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tvCellBgView: UIView!
    @IBOutlet weak var timeSlotLbl: UIView!
    @IBOutlet weak var timeSlotCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    var timeArr: [TimeAvailable] = []
    var divideSize : Double = 0.0
    let maxSlotsPerRow = 5.1
    let timeCellHeight: CGFloat = 36
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tvCellBgView.setCornerRadius(radius: 8, borderColor: .white)
        setupCollectionViewCell()
    }
    
    func setupCollectionViewCell(){
        let nib = UINib(nibName: "TimeCVCell", bundle: nil)
        timeSlotCollectionView.register(nib, forCellWithReuseIdentifier: "TimeCVCell")
    }
    
    
    func setCellData(_data: Restaurant){
        if let imageURL = URL(string: _data.image ?? "") {
            restaurentImg.loadImageFromURL(imageURL)
        }
        nameLbl.text = _data.businessName
        ratingLbl.text = _data.rating
        descLbl.text = _data.description
        locationLbl.text = "Location:" + " " + (_data.address ?? "")
        timeArr = _data.timeAvailable ?? []

        collectionHeightConstraint.constant = updateCollectionViewHeightBasedOnTimeCount(_response: _data)
        timeSlotCollectionView.reloadData()
    }
    func updateCollectionViewHeightBasedOnTimeCount(_response: Restaurant) -> CGFloat {
        let timeCount = _response.timeAvailable?.count ?? 0
        let maxSlotsPerRow = 5
        var rows = Int(ceil(Double(timeCount) / Double(maxSlotsPerRow)))
        if timeCount % maxSlotsPerRow == 2 || timeCount % maxSlotsPerRow == 4 {
            rows += 1
        }
        return CGFloat(rows) * timeCellHeight
    }

    func up1dateCollectionViewHeightBasedOnTimeCount(_response: Restaurant) -> CGFloat {
          let timeCount = _response.timeAvailable?.count ?? 0
          let maxSlotsPerRow = 5
          let rows = Int(ceil(Double(timeCount) / Double(maxSlotsPerRow)))
          let itemsInLastRow = timeCount % maxSlotsPerRow
          let additionalRow = itemsInLastRow > 0 ? 1 : 0
          return CGFloat(rows + additionalRow) * timeCellHeight
      }
}

extension ReastaurentTableCell : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if timeArr.count > 0 {
            return timeArr.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == timeSlotCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCVCell", for: indexPath) as? TimeCVCell else {return UICollectionViewCell()}
            cell.collectionBgView.setCornerRadius(radius: 5.0, borderColor: .white)
            if timeArr.count > 0 {
                cell.setCollectionCellData(_data: timeArr[indexPath.row])
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
}
