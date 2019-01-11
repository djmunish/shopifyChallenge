//
//  JSONParsing.swift
//  shopify_Challenge
//
//  Created by Munish Sehdev on 27/08/18.
//  Copyright © 2018 Munish. All rights reserved.
//

import UIKit

class JSONParsing: NSObject {
    static let shared = JSONParsing()
    func collectionsFetching(data:[[String:Any]])-> Array<CollectionListModel>
    {
        var finalArr = Array<CollectionListModel>()
        for dict in data{
            let imgDic = dict["image"] as? [String:Any] ?? [:]
            let img = imgDic["src"] as? String ?? "NA"
            let collModal = CollectionListModel.init(dict["handle"] as? String ?? "NA", dict["id"] as? Int ?? 0,img,dict["body_html"] as? String ?? "NA")
            finalArr.append(collModal)
        }
        
        return finalArr
    }
    func productsFetching(data:[[String:Any]])-> Array<ProductModel>
    {
        var finalArr = Array<ProductModel>()
        for dict in data{
            let variants = dict["variants"] as? [[String:Any]] ?? []
            let collModal = ProductModel.init(dict["id"] as? String ?? "NA", dict["title"] as? String ?? "NA",self.genInventoryCount(data: variants))
            finalArr.append(collModal)
        }
        
        return finalArr
    }
    
    
    func genInventoryCount(data:[[String:Any]]) -> String {
        var invCount = 0
        for dic in data {
            invCount +=  dic["inventory_quantity"] as? Int ?? 0
        }
        return String(invCount)
    }

}
