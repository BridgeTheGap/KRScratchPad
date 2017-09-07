//
//  ScatchPad.swift
//  iOSClient
//
//  Created by Joshua Park on 31/08/2017.
//  Copyright © 2017 Knowre. All rights reserved.
//

import UIKit

open class ScratchPad: UIView {
    
    open var isDrawingMode: Bool = true
    
    open var lineColor: UIColor = .black
    open var lineWidth: CGFloat = 1.5
    open var eraserWidth: CGFloat = 20.0
    
    private var path: UIBezierPath = {
        let path = UIBezierPath()
        path.lineCapStyle = .round
        return path
    }()
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
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        if let image = self.image, rect == bounds {
            image.draw(in: rect)
        }
        
        if path.bounds.intersects(rect) {
            lineColor.setStroke()
            
            path.lineCapStyle = .round
            path.lineWidth = isDrawingMode ? lineWidth : eraserWidth
            path.stroke(with: isDrawingMode ? .normal : .clear,
                        alpha: 1.0)
        }
        
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        viewImage?.draw(in: rect)
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

        let p1 = touch.location(in: self)
        let p2 = touch.previousLocation(in: self)
        
        if path.isEmpty {
            path.move(to: p1)
        } else {
            path.addQuadCurve(to: isLast ? p1 : midPoint(for: p1, p2: p2),
                              controlPoint: p2)
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
        
        setNeedsDisplay()
    }
    
}

