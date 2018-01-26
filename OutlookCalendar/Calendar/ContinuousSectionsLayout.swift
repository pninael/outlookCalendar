//
//  ContinuousSectionsLayout.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/25/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

protocol ContinuousSectionsLayoutDelegte {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath:IndexPath) -> CGFloat
}

class ContinuousSectionsLayout: UICollectionViewLayout {

    var delegate : ContinuousSectionsLayoutDelegte!
    var numberOfColumns = 1
    
    private var attributesCache = [UICollectionViewLayoutAttributes]()
    private var contentHeight : CGFloat = 0
    
    private var width : CGFloat {
        return collectionView?.bounds.width ?? 0
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        
        if attributesCache.isEmpty,
            let collectionView = collectionView {
            let columnWidth = width / CGFloat(numberOfColumns)
            
            var xOffsets = [CGFloat]()
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * columnWidth)
            }
            
            var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
            
            var column = 0
            
            for section in 0..<collectionView.numberOfSections {
                for item in 0..<collectionView.numberOfItems(inSection: section) {
                    let indexPath = IndexPath(item: item, section: section)
                    let height = delegate.collectionView(collectionView: collectionView, heightForItemAtIndexPath: indexPath)
                    let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = frame
                    attributesCache.append(attributes)
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffsets[column] = yOffsets[column] + height
                    column = column >= (numberOfColumns - 1) ? 0 : column+1
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesCache {
            if rect.intersects(attributes.frame) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
