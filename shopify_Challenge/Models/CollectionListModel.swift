//
//  CollectionListModel.swift
//  shopify_Challenge
//
//  Created by Munish Sehdev on 10/01/19.
//  Copyright © 2019 Munish. All rights reserved.
//

import UIKit

class CollectionListModel: NSObject {
    
    var collName:String = ""
    var collId:String = ""
    var collImg:String = ""
    var collBody:String = ""

    init(_ collName: String, _ collId: Int,_ collImg:String,_ collBody:String) {
        self.collName = collName
        self.collId = String(collId)
        self.collImg = collImg
        self.collBody = collBody

    }
}
