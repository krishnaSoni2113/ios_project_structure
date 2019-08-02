//
//  UserViewModel.swift
//  ProjectStructure
//
//  Created by mac-0005 on 02/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

class UserViewModel {
    
    
    // Add your call staus as a constructor to notify your viewController.
    func login() {
        UserServices().login(para: nil)
    }
}
