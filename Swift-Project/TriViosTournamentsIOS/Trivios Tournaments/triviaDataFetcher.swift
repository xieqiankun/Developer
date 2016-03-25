//
//  DealWithDataPart.swift
//  Trivios Tournaments
//
//  Created by 谢乾坤 on 3/23/16.
//  Copyright © 2016 Purple Gator. All rights reserved.
//

import Foundation

let triviaGenericError = NSError(domain: "An Unknown Error Occurred", code: 1234, userInfo: nil)
let triviaMissingPayloadError = NSError(domain: "Missing payload", code: 1111, userInfo: nil)


func makeRequest(isPrivate: Bool, route: String, type: String, payload: AnyObject, completion: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
    let session = NSURLSession.sharedSession()
    
    var requestSuffix = route
    
    if isPrivate {
        requestSuffix = "api/" + route
    }
    print(requestSuffix)
    print(serverPrefix())
    
    let url = NSURL(string: serverPrefix() + requestSuffix)!
    let request = NSMutableURLRequest(URL: url)
    
    if isPrivate {
        if triviaCurrentUser != nil {
            let userToken = triviaCurrentUser!._id
            if userToken == nil {
                let error = NSError(domain: "User Not Logged In", code: 1234, userInfo: nil)
                completion(data: nil, response: nil, error: error)
                return
            }
            request.setValue(userToken, forHTTPHeaderField: "Authorization")
        }
        else {
            let error = NSError(domain: "User Not Logged In", code: 9999, userInfo: nil)
            completion(data: nil, response: nil, error: error)
            return
        }
    }
    
    var payloadString: NSString?
    if let payloadBool = payload as? Bool where payloadBool == true {
        payloadString = "true"
    } else if let payloadAsString = payload as? String {
        payloadString = payloadAsString
    }
    else {
        var encodingError: NSError?
        let JSONData: NSData?
        do {
            JSONData = try NSJSONSerialization.dataWithJSONObject(payload, options: NSJSONWritingOptions(rawValue: 0))
        } catch let error as NSError {
            encodingError = error
            JSONData = nil
        }
        if encodingError != nil {
            completion(data: nil, response: nil, error: encodingError)
            return
        }
        
        payloadString = NSString(data: JSONData!, encoding: NSUTF8StringEncoding)
    }
    
    let postString = "type=" + type + "&payload=" + (payloadString as! String)
    
    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    request.HTTPMethod = "POST"
    
    
    session.dataTaskWithRequest(request, completionHandler: completion).resume()
}

func parseJSONReply(data: NSData) throws -> Dictionary<String,AnyObject> {
    let value: Dictionary<String,AnyObject>?
    do {
        value = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String,AnyObject>
        return value!
    } catch let error as NSError {
        throw error
    }
}

func dateForString(dateString: String) -> NSDate {
    let rfc3339DateFormatter = NSDateFormatter()
    rfc3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
    rfc3339DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    
    return rfc3339DateFormatter.dateFromString(dateString)!
}


func processResponse(error: NSError?, data: NSData?, completion: (error: NSError?, payload: AnyObject?) -> Void) {
    if error != nil {
        completion(error: error, payload: nil)
    } else {
        var parseError: NSError?
        do {
            let reply = try parseJSONReply(data!)
            if let payload = reply["payload"] as? Dictionary<String,AnyObject> {
                if let errorString = payload["error"] as? String {
                    let apiError = NSError(domain: errorString, code: 1111, userInfo: nil)
                    completion(error: apiError, payload: nil)
                }
                else {
                    completion(error: nil, payload: payload)
                }
            } else if let payload = reply["payload"] as? Array<Dictionary<String,AnyObject>> {
                completion(error: nil, payload: payload)
            } else if let payload: AnyObject = reply["payload"] {
                completion(error: nil, payload: payload)
            } else {
                completion(error: nil, payload: nil) //Some calls can succeed and receive no payload
            }
        } catch let error1 as NSError {
            parseError = error1
            completion(error: parseError, payload: nil)
        }
    }
}