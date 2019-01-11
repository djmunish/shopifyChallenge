//
//  ProductModel.swift
//  shopify_Challenge
//
//  Created by Munish Sehdev on 11/01/19.
//  Copyright © 2019 Munish. All rights reserved.
//

import UIKit

class ProductModel: NSObject {
    var prodName:String = ""
    var prodId:String = ""
    var prodCount:String = ""

    init(_ prodId: String, _ prodName: String,_ prodCount:String) {
        self.prodId = prodId
        self.prodName = prodName
        self.prodCount = prodCount
    }
}
