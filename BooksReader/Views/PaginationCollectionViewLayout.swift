//
//  PaginationCollectionViewLayout.swift
//  BooksReader
//
//  Created by com on 1/5/21.
//

import UIKit
import AnimatedCollectionViewLayout


class InvertedFlowLayout: UICollectionViewFlowLayout {

    // inverting the transform in the layout, rather than directly on the cell,
    // is the only way I've found to prevent cells from flipping during animated
    // cell updates

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.layoutAttributesForItem(at: indexPath)
        attrs?.transform = CGAffineTransform(scaleX: 1, y: -1)
        return attrs
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrsList = super.layoutAttributesForElements(in: rect)
        if let list = attrsList {
            for i in 0..<list.count {
                list[i].transform = CGAffineTransform(scaleX: 1, y: -1)
            }
        }
        return attrsList
    }
    
    override var developmentLayoutDirection: UIUserInterfaceLayoutDirection {
        return.rightToLeft
    }
    
}


public struct PagniationAttributesAnimator: LayoutAttributesAnimator {
    
    public var speed: CGFloat
    
    public init(speed: CGFloat = 0.5) {
        self.speed = speed
    }
    
    public func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes) {
        let position = attributes.middleOffset
        let direction = attributes.scrollDirection
        
        guard let contentView = attributes.contentView else { return }
        
        if abs(position) >= 1 {
            // Reset views that are invisible.
            contentView.frame = attributes.bounds
        } else if direction == .horizontal {
            let width = collectionView.frame.width
            let transitionX = -(width * speed * position)
            let transform = CGAffineTransform(translationX: transitionX, y: 0)
            let newFrame = attributes.bounds.applying(transform)
            
            let transition = CATransition()
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.type = .moveIn
            transition.subtype = .fromLeft
            transition.fillMode = .forwards
            contentView.layer.add(transition, forKey: "animation")
            
            if #available(iOS 14, *) {
                contentView.transform = transform
            } else {
                contentView.frame = newFrame
            }
            
        } else {
            let height = collectionView.frame.height
            let transitionY = -(height * speed * position)
            let transform = CGAffineTransform(translationX: 0, y: transitionY)
            
            // By default, the content view takes all space in the cell
            let newFrame = attributes.bounds.applying(transform)
            
            // We don't use transform here since there's an issue if layoutSubviews is called
            // for every cell due to layout changes in binding method.
            //
            // Update for iOS 14: It seems that setting frame of content view
            // won't work for iOS 14. And transform on the other hand doesn't work pre iOS 14
            // so we adapt the changes here.
            if #available(iOS 14, *) {
                contentView.transform = transform
            } else {
                contentView.frame = newFrame
            }
        }
    }
    
}
