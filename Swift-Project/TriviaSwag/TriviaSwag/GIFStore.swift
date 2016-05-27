//
//  GIFStore.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/27/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

class GIFStore: NSObject {
    
    static let sharedInstance = GIFStore()
    
    var correctGifs = [UIImage]()
    var correctTexts = [String]()
    
    var incorrectGifs = [UIImage]()
    var incorrectTexts = [String]()
    
    
    override init() {
        super.init()
        initStore()
    }
    
    func initStore() {
        // correct
        if let image = UIImage.gifWithName("jackblack") {
            correctGifs.append(image)
            correctTexts.append("Hell Yeah!")
        }
        if let image = UIImage.gifWithName("jimmykimmel") {
            correctGifs.append(image)
            correctTexts.append("Go Shorty, It's Ya Birthday!")
        }
        if let image = UIImage.gifWithName("rockyvictory") {
            correctGifs.append(image)
            correctTexts.append("Victory!!!")
        }
        if let image = UIImage.gifWithName("shooterMcGavin") {
            correctGifs.append(image)
            correctTexts.append("You eat pieces of 💩 for breakfast?")
        }
        if let image = UIImage.gifWithName("solitair") {
            correctGifs.append(image)
            correctTexts.append("YEASSSSS!!")
        }
        if let image = UIImage.gifWithName("ifhedies") {
            correctGifs.append(image)
            correctTexts.append("If he dies, he dies")
        }
        
        
        // incorrect
        if let image = UIImage.gifWithName("mutumbo") {
            incorrectGifs.append(image)
            incorrectTexts.append("No No Noooo!")
        }
        if let image = UIImage.gifWithName("powerrangers") {
            incorrectGifs.append(image)
            incorrectTexts.append("Ahhhhh my brain!")
        }
        if let image = UIImage.gifWithName("steveharvey") {
            incorrectGifs.append(image)
            incorrectTexts.append("Oh boy, not again!")
        }
        if let image = UIImage.gifWithName("vincevaughn") {
            incorrectGifs.append(image)
            incorrectTexts.append("Erroneous on all counts!")
        }
        if let image = UIImage.gifWithName("yousucksimpsons") {
            incorrectGifs.append(image)
            incorrectTexts.append(".... you \"suck\"")
        }
        if let image = UIImage.gifWithName("lahoosaher") {
            incorrectGifs.append(image)
            incorrectTexts.append("La-hoo-sa-her")
        }
        
    }
    
    func getRandomGif(correct:Bool) -> (String, UIImage){
        
        if correct{
            let random = Int(arc4random_uniform(UInt32(correctTexts.count)))
            return (correctTexts[random], correctGifs[random])
        } else {
            let random = Int(arc4random_uniform(UInt32(incorrectTexts.count)))
            return (incorrectTexts[random], incorrectGifs[random])
        }
        
        
    }
    
    
}


















