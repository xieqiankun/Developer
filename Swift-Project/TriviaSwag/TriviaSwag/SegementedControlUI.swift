//
//  SegementedControlUI.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

@IBDesignable class SegementedControlUI: UIControl {
    
    private var figures = [UIImageView]()
    var thumbFigure = UIImageView()

    //setup pictures
    var untoouchedPics = ["LeaderboardButton-Untouched","MapButton-Untouched","TourneyTalkButton-Untouched"]{
        didSet{
            setupFigures()
        }
    }
    var toouchedPics = ["LeaderboardButton-Touched","MapButton-Touched","TourneyTalkButton-Touched"]

    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        
        layer.cornerRadius = frame.height/3
        layer.borderColor = UIColor.clearColor().CGColor
        layer.borderWidth = 1
        
        backgroundColor = UIColor.clearColor()
        setupFigures()
        
        let image = UIImage(named: toouchedPics[0])
        self.thumbFigure.frame = figures[0].frame
        thumbFigure.image = image
        
        insertSubview(thumbFigure, atIndex: 0)
        self.bringSubviewToFront(thumbFigure)
    }


    
    func setupFigures() {
        
        for figure in figures {
            figure.removeFromSuperview()
        }
        figures.removeAll(keepCapacity: true)
        
        for index in 1...untoouchedPics.count {
            let figure = UIImageView(frame: CGRectZero)
            let image = UIImage(named: untoouchedPics[index - 1])
            figure.image = image
            
            self.addSubview(figure)
            figures.append(figure)
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = CGRectGetWidth(selectFrame) / CGFloat(figures.count)
        selectFrame.size.width = newWidth
        thumbFigure.frame = selectFrame
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(figures.count)
        
        for index in 0...figures.count - 1 {
            let figure = figures[index]
            
            let xPosition = CGFloat(index) * labelWidth
            figure.frame = CGRectMake(xPosition, 0, labelWidth, labelHeight)
            
        }
        self.bringSubviewToFront(thumbFigure)

    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        
        var calculatedIndex: Int?
        for(index, figure) in figures.enumerate(){
            
            if figure.frame.contains(location){
                calculatedIndex = index
            }
        }
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActionsForControlEvents(.ValueChanged)
        }
        
        return false
    }


    
    func displayNewSelectedIndex() {
        
        let image = UIImage(named: toouchedPics[selectedIndex])
        self.thumbFigure.frame = figures[selectedIndex].frame
        thumbFigure.image = image
        
    }
    
    
    
    
    
    
}
