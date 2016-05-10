//
//  GameViewController.swift
//  DesignPatternsInSwift
//
//  Created by Joel Shapiro on 9/23/14.
//  Copyright (c) 2014 RepublicOfApps, LLC. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  
  private var shapeFactory: ShapeFactory!
  private var shapeViewBuilder: ShapeViewBuilder!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 1 ***** ADDITION
    shapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())
    
    shapeViewBuilder = ShapeViewBuilder(shapeViewFactory: shapeViewFactory)
    shapeViewBuilder.fillColor = UIColor.brownColor()
    shapeViewBuilder.outlineColor = UIColor.orangeColor()
    
    shapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
    turnController = TurnController(shapeFactory: shapeFactory, shapeViewBuilder: shapeViewBuilder)
    beginNextTurn()


  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  private func beginNextTurn() {
    // 1
    let shapeViews = turnController.beginNewTurn()
    
    shapeViews.0.tapHandler = {
      tappedView in
      // 2
      self.gameView.score += self.turnController.endTurnWithTappedShape(tappedView.shape)
      self.beginNextTurn()
    }
    
    // 3
    shapeViews.1.tapHandler = shapeViews.0.tapHandler
    
    gameView.addShapeViews(shapeViews)
  }
  private var gameView: GameView { return view as! GameView }
  
  // 3 ***** ADDITION
  private var shapeViewFactory: ShapeViewFactory!
  private var turnController: TurnController!

}