//
//  ContinuousSectionsLayout.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/25/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

// A ContinuousSectionsGridLayout delegate
protocol ContinuousSectionsGridLayoutDelegte {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath:IndexPath) -> CGFloat
}

// A custom CollectionViewLayout for displaying cells in a grig with continuous sections, so that
// sections are not being break to new lines
class ContinuousSectionsGridLayout: UICollectionViewLayout {

    var delegate : ContinuousSectionsGridLayoutDelegte!
    
    // the number of columns in the grid
    var numberOfColumns = 1
    
    // a cache to store calculated layout attributes
    private var attributesCache = [IndexPath : UICollectionViewLayoutAttributes]()
    
    // the contet height
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
                    let frame = CGRect(x: xOffsets[column],
                                       y: yOffsets[column],
                                       width: columnWidth,
                                       height: height)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = frame
                    attributesCache[indexPath] = attributes
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffsets[column] = yOffsets[column] + height
                    
                    column = column >= (numberOfColumns - 1) ? 0 : column + 1
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesCache.values {
            if rect.intersects(attributes.frame) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesCache[indexPath]
    }
}
