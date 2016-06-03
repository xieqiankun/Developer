//
//  triviaGifStore.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/31/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

public class triviaGifStore: NSObject {
    
    var correctGifs: [triviaGif]?
    var incorrectGifs: [triviaGif]?
    
    init(payload:[String: AnyObject]){
        if let gifs = payload["gifs"] as? [String:AnyObject]{
            if let corrects = gifs["correct"] as? [[String: String]] {
                print(" I am here ----------")
                var c = [triviaGif]()
                for correct in corrects {
                    let gif = triviaGif(payload: correct)
                    c.append(gif)
                }
                correctGifs = c
            }
            if let incorrects = gifs["incorrect"] as? [[String: String]] {
                var c = [triviaGif]()
                for incorrect in incorrects {
                    let gif = triviaGif(payload: incorrect)
                    c.append(gif)
                }
                incorrectGifs = c
            }
        }
        
    }
    
    func getRandomGif(correct:Bool) -> triviaGif{
        
        if correct{
            let random = Int(arc4random_uniform(UInt32(correctGifs!.count)))
            return correctGifs![random]
        } else {
            let random = Int(arc4random_uniform(UInt32(incorrectGifs!.count)))
            return incorrectGifs![random]
        }
        
        
    }
    
    
    
}


public class triviaGif {
    
    public var image: String?
    public var text: String?
    
    init(payload: [String: String]) {
        
        if let _image = payload["image"]{
            image = _image
        }
        if let _text = payload["text"]{
            text = _text
        }
        
        
    }
    
    
}




