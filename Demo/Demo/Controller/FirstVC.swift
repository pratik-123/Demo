//
//  FirstVC.swift
//  Demo
//
//  Created by Bunty on 13/02/17.
//  Copyright © 2017 Bunty. All rights reserved.
//

import UIKit

class FirstVC: UIViewController , UITableViewDelegate,UITableViewDataSource , UISearchBarDelegate{

    let userObj : Users =  Users()
    var usersArray : [Users] = []
    
    var isSearch : Bool = false
    var serchUserArray : [Users] = []
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        searchField.delegate = self
        searchField.showsCancelButton = false

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
        tableView.tableFooterView = UIView()
        
        if prefrence.integer(forKey: "isFirstDataGet") == 0
        {
            getCategoryData()
        }
        else
        {
            userObj.selectRecord()
            self.usersArray =  self.userObj.getUsers()
            self.tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    func getCategoryData()
    {
        let param  = ["start":"0","category_id":"0","user_id":"2","device_os":"iOS","device_date":"2017-02-03 04:16:22 +0000","device_id":"asd","os_version":"10.0","device_token":""]
        
        let url = "http://ec2-52-43-219-5.us-west-2.compute.amazonaws.com/shareiza/API/sh_post_list.php"
        
        SendServerRequest(type: "POST", baseURL: url, param: param as AnyObject, requestCompleted: {(success,msg,jsonObj) in
            
            if success
            {
                let json = jsonObj as! NSDictionary
                
                if json["success"] is Int && json["success"] as! Int == 1
                {
                    guard let jsonArray = json["array_sh_post_list"] as? NSArray else {
                        
                        print("error while data retrive")
                        return
                    }
                    
                    self.userObj.setJsonData(jsonArray: jsonArray)
                    self.usersArray =  self.userObj.getUsers()
                    self.tableView.reloadData()
                    
                    prefrence.set(1, forKey: "isFirstDataGet")
                    
                }
                else if json["success"] is Int && json["success"] as! Int == 0
                {
                    
                }
            }
            else
            {
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch
        {
            return serchUserArray.count
        }
        else
        {
            return usersArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var userData = Users() //usersArray[indexPath.row]
        
        if isSearch
        {
            userData = serchUserArray[indexPath.row]
        }
        else
        {
            userData = usersArray[indexPath.row]
        }
        
        let cell : FirstCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FirstCell
        
        cell.lblName.text = userData.name
        cell.lblCity.text = userData.city
        cell.lblAddress.text = userData.address
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    //MARK: SerchBar Delegate 
    //MARK: Search Bar Delegate
    /*========================================================================
     * Function Name: Sarch bar
     * Function Purpose: adding search bar method add by bunty 01-06-2016
     * =====================================================================*/
    //MARK: SearchBar delegate method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.isEmpty{
            isSearch = false
            tableView.reloadData()
        } else {
            //  println(" search text %@ ",searchBar.text as NSString)
            isSearch = true
            serchUserArray = []
            
            for i in 0..<usersArray.count
            {
                let userObj = usersArray[i]
                let name = userObj.address
                if name.lowercased().range(of: searchText.lowercased())  != nil
                {
                    serchUserArray.append(usersArray[i])
                }
            }
            tableView.reloadData()
        }
    }
    //MARK: Seachbar Search Button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    //=========end search bar delegate method
    
}


