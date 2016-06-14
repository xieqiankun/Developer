//
//  GradientView.swift
//  StoreSearch
//
//  Created by 谢乾坤 on 4/27/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit
class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        autoresizingMask = [.FlexibleWidth , .FlexibleHeight]
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        autoresizingMask = [.FlexibleWidth , .FlexibleHeight]
    }
    override func drawRect(rect: CGRect) {
        // 1 First you create two arrays that contain the “color stops” for the gradient. The first color (0, 0, 0, 0.3) is a black color that is mostly transparent. It sits at location 0 in the gradient, which represents the center of the screen because you’ll be drawing a circular gradient.
        // The second color (0, 0, 0, 0.7) is also black but much less transparent and sits at location 1, which represents the circumference of the gradient’s circle. Remember that in UIKit and also in Core Graphics, colors and opacity values don’t go from 0 to 255 but are fractional values between 0.0 and 1.0.
        // The 0 and 1 from the locations array represent percentages: 0% and 100%, respectively. If you have more than two colors, you can specify the percentages of where in the gradient you want to place these colors.
        let components: [CGFloat] = [ 0, 0, 0, 0.3, 0, 0, 0, 0.7 ]
        let locations: [CGFloat] = [ 0, 1 ]
        
        
        // 2 With those color stops you can create the gradient. This gives you a new CGGradient object. This is not an traditional object, so you cannot send it messages by doing gradient.methodName(). But it’s still some kind of data structure that lives in memory, and the gradient constant refers to it. (Such objects are called “opaque” types, or “handles”. They are relics from iOS frameworks that are written in the C language, such as Core Graphics.)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents( colorSpace, components, locations, 2)
        
        
        // 3 Now that you have the gradient object, you have to figure out how big you need to draw it. The CGRectGetMidX() and CGRectGetMidY() functions return the center point of a rectangle. That rectangle is given by bounds, a CGRect object that describes the dimensions of the view.
        let x = CGRectGetMidX(bounds)
        let y = CGRectGetMidY(bounds)
        let point = CGPoint(x: x, y : y)
        let radius = max(x, y)
        // 4
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawRadialGradient(context, gradient, point, 0, point, radius, .DrawsAfterEndLocation)
    }
}





