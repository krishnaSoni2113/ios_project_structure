//
//  UserViewModel.swift
//  ProjectStructure
//
//  Created by mac-0005 on 02/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit

class UserViewModel {

    var status: KxSwift<Bool> = KxSwift<Bool>(false)
    var name: KxSwift<String?> = KxSwift<String?>(nil)
    var userId: KxSwift<Int> = KxSwift<Int>(0)
    var arrUserId: KxSwift<[Int]> = KxSwift<[Int]>([])
    var image: KxSwift<UIImage?> = KxSwift<UIImage?>(nil)
    
    // Add your call staus as a constructor to notify your viewController.
    func login() {
        
        UserServices().login(para: nil)
        
        // This will call when value has change from any where..
        status.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            if self.status.value {
                print("True === ")
            }else {
                print("False === ")
            }
            
        }
        
        // This will call when value has change from any where..
        name.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            print(self.name.value ?? "")
        }
        
        // This will call when value has change from any where..
        userId.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            print(self.userId.value)
        }
        
        arrUserId.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            print(self.arrUserId.value)
        }
        
        
    }
}
