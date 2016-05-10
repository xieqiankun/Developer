//
//  ShapeViewBuilder.swift
//  DesignPatternsInSwift
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 RepublicOfApps, LLC. All rights reserved.
//

import Foundation
import UIKit

class ShapeViewBuilder {
  // 1
  var showFill  = true
  var fillColor = UIColor.orangeColor()
  
  // 2
  var showOutline  = true
  var outlineColor = UIColor.grayColor()
  
  // 3
  init(shapeViewFactory: ShapeViewFactory) {
    self.shapeViewFactory = shapeViewFactory
  }
  
  // 4
  func buildShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes)
    configureShapeView(shapeViews.0)
    configureShapeView(shapeViews.1)
    return shapeViews
  }
  
  // 5
  private func configureShapeView(shapeView: ShapeView) {
    shapeView.showFill  = showFill
    shapeView.fillColor = fillColor
    shapeView.showOutline  = showOutline
    shapeView.outlineColor = outlineColor
  }
  
  private var shapeViewFactory: ShapeViewFactory
}