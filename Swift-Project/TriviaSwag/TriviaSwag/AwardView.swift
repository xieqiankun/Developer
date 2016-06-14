//
//  AwardView.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 6/14/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

class AwardView: UIView {
    
    @IBOutlet weak var imageview: UIImageView!
    
    let gradientLayer = CAGradientLayer()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()

    }
    
    func initView() {
        
        backgroundColor = UIColor.clearColor()
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [ UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8).CGColor,UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).CGColor]
        
    }
    
    override func layoutSubviews() {
        
        gradientLayer.frame = self.frame

    }

    func setImage(nsurl: NSURL){
        
     
        imageview.kf_setImageWithURL(nsurl)

    }
    
    func applyBlurEffect(image: UIImage) -> UIImage{
        var imageToBlur = CIImage(image: image)
        var blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter!.setValue(imageToBlur, forKey: "inputImage")
        blurfilter!.setValue(5, forKey: "inputRadius")
        var resultImage = blurfilter!.valueForKey("outputImage") as! CIImage
        var blurredImage = UIImage(CIImage: resultImage)
        
        return blurredImage
    }
}