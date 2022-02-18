//
//  ConnectionView.swift
//  ConnectTheDots
//
//  Created by Manish Kumar on 2022-02-17.
//

import UIKit

class ConnectionView: UIView {
    var connectionDragged: (() -> Void)? /// to allow the caller to take action after
    var draggingFinished: (() -> Void)? /// to allow the caller to take action after
    var touchStartPos = CGPoint.zero
    var nextConnection: ConnectionView!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStartPos = touch.location(in: self)
        
        /// The `touchStartPos` is set relative to lop-left corner of the `ConnectionView` whereas we are moving the views by changing
        /// their `center` property. So need to make `touchStartPos` relative to the center.
        touchStartPos.x -= frame.size.width / 2
        touchStartPos.y -= frame.size.width / 2
        
        /// Make it slightly bigger to make it more prominent
        transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        
        /// If we don't bring it to front, the circle might slide `under` other circles when dragged.
        superview?.bringSubviewToFront(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let newPoint = touch.location(in: superview)
        center = CGPoint(x: newPoint.x - touchStartPos.x, y: newPoint.y - touchStartPos.y)
        connectionDragged?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        transform = .identity
        draggingFinished?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}

