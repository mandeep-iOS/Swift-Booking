//
//  TimeCVCell.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import UIKit

class TimeCVCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionBgView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    
    func setCollectionCellData(_data: TimeAvailable){
        timeLbl.text = _data.time
    }
    
}
