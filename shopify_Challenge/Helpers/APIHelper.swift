//
//  APIHelper.swift
//  shopify_Challenge
//
//  Created by Munish on 10/01/19.
//  Copyright © 2019 Munish. All rights reserved.
//


import UIKit
typealias callbackAPI = (([String:Any])->Void)

struct Configuration {
    let kBaseUrl = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
}


class APIHelper: NSObject{
    let config = Configuration()
    var request: URLRequest?
    var task: URLSessionDataTask?
    
    static let sharedInstance = APIHelper()
    
    func productCollectURL(_ id: String) -> String {
        return "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    }
    func productListURL(_ ids: String) -> String {
        return "https://shopicruit.myshopify.com/admin/products.json?ids=\(ids)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    }
    
    func callgetAPI(url: String, callback:@escaping callbackAPI) {
        let url = URL(string:url)
        let reachability : Reachability!
        reachability = Reachability.init()
        if !(reachability?.isReachable)!{
            let dataDict = ["success":"0","message": "Please check your internet connection.", "statusCode": "50"] as [String:Any]
            callback(dataDict)
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20.0)
        request?.httpMethod = "GET"
        task = URLSession.shared.dataTask(with: request!) { data, response, error in
            DispatchQueue.main.async(execute: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if((error) != nil || data?.count == 0) {
                    let dataDict = ["success":"0","message":error!.localizedDescription as String, "statusCode": "50"] as [String:Any]
                    callback(dataDict)
                    return
                } else {
                    let _: NSError?
                    do {
                        let jsonResult: AnyObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as AnyObject

                        if jsonResult is [String:Any]
                        {
                            callback((jsonResult as? [String:Any])!)
                        }else{let dataDict = ["success":"0","message": "Something went wrong, please try again later.", "statusCode": "50"] as [String:Any]
                            callback(dataDict)
                            return
                        }
                    }catch{
                        let dataDict = ["success":"0","message": "Something went wrong, please try again later.", "statusCode": "50"] as [String:Any]
                        callback(dataDict)
                        return
                    }
                }
            })
        }
        task?.resume()
    }
    
   
}

