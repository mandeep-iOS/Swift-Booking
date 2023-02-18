//
//  CustomCollectionViewFlowLayout.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let maxSlotsPerRow = 5
    let cellHeight: CGFloat = 33
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        let contentWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
        let availableWidth = contentWidth - minimumInteritemSpacing * CGFloat(maxSlotsPerRow - 1)
        let slotWidth = availableWidth / CGFloat(maxSlotsPerRow)
        
        itemSize = CGSize(width: slotWidth, height: cellHeight)
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        minimumInteritemSpacing = 3
        minimumLineSpacing = 3
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }
        
        let allAttributes = (0..<collectionView.numberOfSections).flatMap { (sectionIndex) -> [UICollectionViewLayoutAttributes] in
            let sectionAttributes = (0..<collectionView.numberOfItems(inSection: sectionIndex)).compactMap { (itemIndex) -> UICollectionViewLayoutAttributes? in
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                self.configureAttributes(itemAttributes, for: indexPath)
                return itemAttributes
            }
            return sectionAttributes
        }
        return allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        configureAttributes(attributes, for: indexPath)
        return attributes
    }
    
    func configureAttributes(_ attributes: UICollectionViewLayoutAttributes, for indexPath: IndexPath) {
        let column = indexPath.item % maxSlotsPerRow
        let row = indexPath.item / maxSlotsPerRow
        
        attributes.frame = CGRect(x: CGFloat(column) * (itemSize.width + minimumInteritemSpacing), y: CGFloat(row) * (itemSize.height + minimumLineSpacing), width: itemSize.width, height: itemSize.height)
    }
    
}
