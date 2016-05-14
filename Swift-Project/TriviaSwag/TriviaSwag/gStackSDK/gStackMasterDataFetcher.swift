//
//  Master Data Fetcher.swift
//  gStack Client Framework
//
//  Created by Evan Bernstein on 8/17/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//  Modified by QiankunXie on 3/23/16.
//

import Foundation

let gStackGenericError = NSError(domain: "An Unknown Error Occurred", code: 1234, userInfo: nil)
let gStackMissingPayloadError = NSError(domain: "Missing payload", code: 1111, userInfo: nil)

func gStackMakeRequest(isPrivate: Bool, route: String, type: String, payload: AnyObject, completion: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
    
    let session = NSURLSession.sharedSession()
    
    var requestSuffix = route
    
    if isPrivate {
        requestSuffix = "qstacks/" + route
    } else {
        requestSuffix = "qstack/" + route
    }

    let url = NSURL(string: serverPrefix() + requestSuffix)!
    let request = NSMutableURLRequest(URL: url)
    
    print(url)
    
    if isPrivate {
            let gameToken = gStackAppIDToken
            if gameToken == nil {
                let error = NSError(domain: "Without app token", code: 1234, userInfo: nil)
                completion(data: nil, response: nil, error: error)
                return
            }
            request.setValue(gameToken, forHTTPHeaderField: "Authorization")
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

func gStackParseJSONReply(data: NSData) throws -> AnyObject {
    do {
        let value = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        return value
    } catch let error as NSError {
        throw error
    }
}

func gStackDateForString(dateString: String) -> NSDate {
    let rfc3339DateFormatter = NSDateFormatter()
    rfc3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
    rfc3339DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    
    return rfc3339DateFormatter.dateFromString(dateString)!
}


func gStackProcessResponse(error: NSError?, data: NSData?, completion: (error: NSError?, payload: AnyObject?) -> Void) {
    
    if error != nil {
        completion(error: error, payload: nil)
    } else {
        var parseError: NSError?
        do {
            let reply = try gStackParseJSONReply(data!)
            //print(reply)
            if let payload = reply["payload"] as? Dictionary<String,AnyObject> {
                if let errorString = payload["error"] as? String {
                    // control api error, like token expire
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
            } else if let payload = reply as?  Array<Dictionary<String,AnyObject>>{
                completion(error: nil, payload: payload) // Only fetch tournaments will get here for now
            } else {
                completion(error: nil, payload: nil) //Some calls can succeed and receive no payload
            }

        } catch let error1 as NSError {
            parseError = error1
            completion(error: parseError, payload: nil)
        }
    }
}
