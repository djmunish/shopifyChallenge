//
//  ViewController.swift
//  shopify_Challenge
//
//  Created by Munish Sehdev on 10/01/19.
//  Copyright © 2019 Munish. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class collectionListCell:UITableViewCell{
    @IBOutlet weak var collectionNameLbl: UILabel!
    @IBOutlet weak var collImg: UIImageView!
}
class ViewController: UIViewController {
    var array = [CollectionListModel]()
    let config = Configuration()
    var productsArray = [ProductModel]()
    var pIDS = ""
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.showLoader(message: "Loading...", vc: self)
        APIHelper.sharedInstance.callgetAPI(url: config.kBaseUrl) { (dic) in
            self.hideLoader(vc: self)
            let data = dic["custom_collections"] as! [[String : Any]]
            self.array = JSONParsing.shared.collectionsFetching(data:data)
            self.tblView.reloadData()
        }
    }
    
    func getProductCollects(prodColl:CollectionListModel) {
        self.showLoader(message: "Loading...", vc: self)
        pIDS = ""
        let url = APIHelper.sharedInstance.productCollectURL(prodColl.collId)
        APIHelper.sharedInstance.callgetAPI(url: url) { (dic) in
            let data = dic["collects"] as! [[String : Any]]
            self.genPIDS(data: data, coll:prodColl)
        }
    }
    func getProductLists(_ coll:CollectionListModel) {
        let url = APIHelper.sharedInstance.productListURL(pIDS)
        APIHelper.sharedInstance.callgetAPI(url: url) { (dic) in
            self.hideLoader(vc: self)
            let data = dic["products"] as! [[String : Any]]
            self.productsArray = JSONParsing.shared.productsFetching(data:data)
            self.performSegue(withIdentifier: "productSegue", sender: coll)
        }
    }
    func genPIDS(data:[[String:Any]], coll:CollectionListModel) {
        for dic in data {
            pIDS = pIDS + "," + String(dic["product_id"] as? Int ?? 0)
        }
        pIDS.remove(at: pIDS.startIndex)
        getProductLists(coll)
    }
    
    
    // MARK: - Loader functions
    func showLoader(message:String,vc:UIViewController)  {
        let loadingNotification = MBProgressHUD.showAdded(to: vc.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
    }
    func hideLoader(vc:UIViewController)  {
        MBProgressHUD.hide(for: vc.view, animated: true)
    }
    
    
    
    // MARK:- Segue Action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "productSegue") {
            let controller = (segue.destination as! ProductListViewController)
            let coll = sender as! CollectionListModel
            controller.prodData = self.productsArray
            controller.collData = coll
        }
    }

}
// MARK: - TableView Delegates & Datasource

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if array.count == 0{
            tableView.isScrollEnabled = false
            let noDataLabel = UILabel(frame: CGRect(x : 0, y : 0, width : tblView.bounds.size.width, height : tblView.bounds.size.height))
            noDataLabel.text = "No result Found"
            noDataLabel.font = UIFont(name: "Avenir Next Medium", size: 14)
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = NSTextAlignment.center
            tblView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        else {
            tblView.backgroundView = nil
            tableView.isScrollEnabled = true
            tableView.separatorStyle = .singleLine
            return array.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionListCell") as! collectionListCell
        let currMem = array[indexPath.row] as CollectionListModel
        cell.collectionNameLbl.text = currMem.collName
        if let imageUrl = URL.init(string: currMem.collImg) {
            cell.collImg.kf.setImage(with: imageUrl)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currColl = array[indexPath.row] as CollectionListModel
        self.getProductCollects(prodColl: currColl)
    }
}

