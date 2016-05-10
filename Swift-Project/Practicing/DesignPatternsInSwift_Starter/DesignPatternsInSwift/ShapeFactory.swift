//
//  ShapeFactory.swift
//  DesignPatternsInSwift
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 RepublicOfApps, LLC. All rights reserved.
//

import Foundation
import UIKit

// 1
protocol ShapeFactory {
  func createShapes() -> (Shape, Shape)
}

class SquareShapeFactory: ShapeFactory {
  // 2
  var minProportion: CGFloat
  var maxProportion: CGFloat
  
  init(minProportion: CGFloat, maxProportion: CGFloat) {
    self.minProportion = minProportion
    self.maxProportion = maxProportion
  }
  
  func createShapes() -> (Shape, Shape) {
    // 3
    let shape1 = SquareShape()
    shape1.sideLength = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    // 4
    let shape2 = SquareShape()
    shape2.sideLength = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    // 5
    return (shape1, shape2)
  }
}

class CircleShapeFactory: ShapeFactory {
  var minProportion: CGFloat
  var maxProportion: CGFloat
  
  init(minProportion: CGFloat, maxProportion: CGFloat) {
    self.minProportion = minProportion
    self.maxProportion = maxProportion
  }
  
  func createShapes() -> (Shape, Shape) {
    // 1
    let shape1 = CircleShape()
    shape1.diameter = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    // 2
    let shape2 = CircleShape()
    shape2.diameter = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    return (shape1, shape2)
  }
}