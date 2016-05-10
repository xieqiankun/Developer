//
//  Turn.swift
//  DesignPatternsInSwift
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 RepublicOfApps, LLC. All rights reserved.
//

import Foundation

class Turn {
  // 1
  let shapes: [Shape]
  var matched: Bool?
  
  init(shapes: [Shape]) {
    self.shapes = shapes
  }
  
  // 2
  func turnCompletedWithTappedShape(tappedShape: Shape) {
    var maxArea = shapes.reduce(0) { $0 > $1.area ? $0 : $1.area }
    matched = tappedShape.area >= maxArea
  }
}