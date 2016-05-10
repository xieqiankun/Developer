//
//  ShapeViewFactory.swift
//  DesignPatternsInSwift
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 RepublicOfApps, LLC. All rights reserved.
//

import Foundation
import UIKit

// 1
protocol ShapeViewFactory {
  // 2
  var size: CGSize { get set }
  // 3
  func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView)
}

class SquareShapeViewFactory: ShapeViewFactory {
  var size: CGSize
  
  // 1
  init(size: CGSize) {
    self.size = size
  }
  
  func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    // 2
    let squareShape1 = shapes.0 as! SquareShape
    let shapeView1 =
      SquareShapeView(frame: CGRect(x: 0,
        y: 0,
        width: squareShape1.sideLength * size.width,
        height: squareShape1.sideLength * size.height))
    shapeView1.shape = squareShape1
    
    // 3
    let squareShape2 = shapes.1 as! SquareShape
    let shapeView2 =
      SquareShapeView(frame: CGRect(x: 0,
        y: 0,
        width: squareShape2.sideLength * size.width,
        height: squareShape2.sideLength * size.height))
    shapeView2.shape = squareShape2
    
    // 4
    return (shapeView1, shapeView2)
  }
}

class CircleShapeViewFactory: ShapeViewFactory {
  var size: CGSize
  
  init(size: CGSize) {
    self.size = size
  }
  
  func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    let circleShape1 = shapes.0 as! CircleShape
    // 1
    let shapeView1 = CircleShapeView(frame: CGRect(
      x: 0,
      y: 0,
      width: circleShape1.diameter * size.width,
      height: circleShape1.diameter * size.height))
    shapeView1.shape = circleShape1
    
    let circleShape2 = shapes.1 as! CircleShape
    // 2
    let shapeView2 = CircleShapeView(frame: CGRect(
      x: 0,
      y: 0,
      width: circleShape2.diameter * size.width,
      height: circleShape2.diameter * size.height))
    shapeView2.shape = circleShape2
    
    return (shapeView1, shapeView2)
  }
}