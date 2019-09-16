//
//  UserServices.swift
//  ProjectStructure
//
//  Created by Krishna Soni on 02/08/19.
//  Copyright © 2019 Krishna Soni. All rights reserved.
//

import Foundation

class UserServices {
 
    init() {
    }
    
    // Add your call back model as a constructor to notify you view model class.
    func login(para: [String: Any]?) {
        
        let dict = ["email_or_mobile" : "krishnasoni2113@gmail.com",
                    "password" : "132456789",
                    "type" : "1",
                    "country_id" : "51",
                    "latitude" : 0.0,
                    "longitude" : 0.0] as [String : AnyObject]
        
        _ = Networking.sharedInstance.apiService(apiTag: "login", param: dict, apiMethod: .post, success: { (task, response, data) in
            
            print("response ==== ")
            
        }, failure: { (task, response, error) in
            
            print("error ==== ")
            
        })
        
    }
}
