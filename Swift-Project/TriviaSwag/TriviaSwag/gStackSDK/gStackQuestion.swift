//
//  gStackQuestion.swift
//  gStackSDK
//
//  Created by Evan Bernstein on 8/19/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

public class gStackQuestion: NSObject {
    public var _zone: String?
    public var category: String?
    public var questionBody: String?
    public var reason: String?
    public var answers: Array<String>? //First answer is always correct answer
    
    func flagDictionary() -> Dictionary<String,AnyObject> {
        var dictionary = ["zone":"","category":"","questionBody":"","reason":""]
        if _zone != nil {
            dictionary["zone"] = _zone!
        }
        if category != nil {
            dictionary["category"] = category!
        }
        if questionBody != nil {
            dictionary["questionBody"] = questionBody!
        }
        if reason != nil {
            dictionary["reason"] = reason!
        }
        return dictionary
    }
    
    func submitDictionary() -> Dictionary<String,AnyObject> {
        var dictionary = ["zone":"","category":"","question":"","answers":[]]
        if _zone != nil {
            dictionary["zone"] = _zone!
        }
        if category != nil {
            dictionary["category"] = category!
        }
        if questionBody != nil {
            dictionary["question"] = questionBody!
        }
        if answers != nil {
            dictionary["answers"] = answers!
        }
        return dictionary
    }
    
    public init(aZone: String, _category: String, _questionBody: String, _answers: Array<String>) {
        super.init()
        _zone = aZone
        category = _category
        questionBody = _questionBody
        answers = _answers
    }
    
    public init(aZone: String, _category: String, _questionBody: String, _reason: String) {
        _zone = aZone
        category = _category
        questionBody = _questionBody
        reason = _reason
    }
}
