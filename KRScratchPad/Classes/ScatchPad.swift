//
//  ScatchPad.swift
//  iOSClient
//
//  Created by Joshua Park on 31/08/2017.
//  Copyright © 2017 Knowre. All rights reserved.
//

import UIKit

/**
 ScratchPad allows users to easily draw/erase natural-looking strokes on a view.
 */
open class ScratchPad: UIView {
    
    /// A boolean value that indicates whether the ScratchPad is in a drawing mode.
    open var isDrawingMode: Bool = true
    
    /// The color of the drawn line.
    open var lineColor: UIColor = .black
    
    /// The width of the drawn line.
    open var lineWidth: CGFloat = 1.5
    
    /// The width of the erased line.
    open var eraserWidth: CGFloat = 20.0
    
    /**
     A boolean value that indicates whether
     there is any history of drawing or erasing.
     
     If the user draws a line and erases it,
     the value of `isEmpty` will return `false`,
     since there is history of drawing.
     
     The value will be `true` only when the view has
     no history of drawing or after `clear()` has been called.
     
     - Note: This property is subject to change in the future
        to indicate whether there are any visible lines
        currently present on the view.
     */
    public final var isEmpty: Bool {
        return image == nil
    }
    
    private var path: UIBezierPath = {
        let path = UIBezierPath()
        path.lineCapStyle = .round
        return path
    }()
    
    /// An composite image of the past drawing and erasing strokes.
    private var image: UIImage?
    
    // MARK: - Interface
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    override open func draw(_ rect: CGRect) {
        if let image = self.image {
            image.draw(in: bounds)
        }
        
        if path.bounds.intersects(rect) {
            lineColor.setStroke()
            
            path.lineCapStyle = .round
            path.lineWidth = isDrawingMode ? lineWidth : eraserWidth
            path.stroke(with: isDrawingMode ? .normal : .clear,
                        alpha: 1.0)
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        register(touch: touches.first!)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        register(touch: touches.first!)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        register(touch: touches.first!, isLast: true)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        path = UIBezierPath()
        setNeedsDisplay()
    }
    
    /// Clears all strokes on the ScratchPad.
    open func clear() {
        path = UIBezierPath()
        image = nil
        setNeedsDisplay()
    }
    
    // MARK: - Private
    
    private func register(touch: UITouch, isLast: Bool = false) {
        func midPoint(for p1: CGPoint, p2: CGPoint) -> CGPoint {
            return CGPoint(x: (p1.x + p2.x) * 0.5,
                           y: (p1.y + p2.y) * 0.5)
        }

        let p = touch.location(in: self)
        let pp1 = touch.previousLocation(in: self)
        let pp2 = path.isEmpty ? p : path.currentPoint
        let mp = midPoint(for: p, p2: pp1)
        
        if path.isEmpty {
            path.move(to: p)
        } else {
            path.addQuadCurve(to: isLast ? p : mp,
                              controlPoint: pp1)
        }
        
        if isLast {
            path.move(to: touch.location(in: self))
        
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
            
            if let image = self.image { image.draw(in: bounds) }
            
            lineColor.setStroke()
            
            path.lineCapStyle = .round
            path.lineWidth = isDrawingMode ? lineWidth : eraserWidth
            path.stroke(with: isDrawingMode ? .normal : .clear,
                        alpha: 1.0)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            path = UIBezierPath()
        }
        
        let padding = (isDrawingMode ? lineWidth : eraserWidth)*2
        
        let x1 = isLast ? p.x : mp.x
        let y1 = isLast ? p.y : mp.y

        let origin1 = CGPoint(x: min(pp1.x, x1),
                              y: min(pp1.y, y1))
        let size1 = CGSize(width: abs(x1 - pp1.x),
                           height: abs(y1 - pp1.y))
        let rect1 = CGRect(origin: origin1,
                           size: size1)
            .insetBy(dx: -padding,
                     dy: -padding)
        
        let origin2 = CGPoint(x: min(pp1.x, pp2.x),
                              y: min(pp1.y, pp2.y))
        let size2 = CGSize(width: abs(pp2.x - pp1.x),
                           height: abs(pp2.y - pp1.y))
        let rect2 = CGRect(origin: origin2,
                           size: size2)
            .insetBy(dx: -padding,
                     dy: -padding)
        
        setNeedsDisplay(rect2)
        setNeedsDisplay(rect1)
    }
    
}

