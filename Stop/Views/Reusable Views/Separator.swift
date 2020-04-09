//
//  Line.swift
//  ActiveCitizen
//
//  Created by Marcos Vicente on 26.03.2020.
//  Copyright © 2020 Antares Software. All rights reserved.
//

import UIKit


enum Line: Int {
    case normal
    case vertical
    case dotted
}

@IBDesignable
class Separator: UIView {
    
    var type: Line = .normal
    
    @IBInspectable var lineColor: UIColor = .lightGray
    
    // IB: use the adapter
    @IBInspectable var lineType: Int {
        get {
            return self.type.rawValue
        }
        set {
            self.type = Line(rawValue: newValue) ?? .normal
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        chooseLineType(type: type)
    }
    
    
    func chooseLineType(type: Line) {
        switch type.rawValue {
        case 0:
            drawLine()
        case 1:
            drawVerticalLine()
        case 2:
            drawDottedLine()
        default:
            fatalError("No option available for inserted value!")
        }
    }
    
    func drawLine() {
        let line = UIBezierPath()
        
        line.move(to: CGPoint(x: 0, y: bounds.height / 2))
        line.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 2))
        line.lineWidth = 1
        lineColor.setStroke()
        line.stroke()
    }
    
    func drawVerticalLine() {
        let line = UIBezierPath()
        
        line.move(to: CGPoint(x: bounds.width / 2, y: 0))
        line.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))
        line.lineWidth = 1
        lineColor.setStroke()
        line.stroke()
    }
    
    func drawDottedLine() {
        let line = UIBezierPath()
        let dots: [CGFloat] = [0.0, 2.0]
        
        line.move(to: CGPoint(x: 0, y: bounds.height / 2))
        line.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 2))
        line.setLineDash(dots, count: dots.count, phase: 0.0)
        line.lineCapStyle = .round
        line.lineWidth = 1
        lineColor.setStroke()
        line.stroke()
    }

}
