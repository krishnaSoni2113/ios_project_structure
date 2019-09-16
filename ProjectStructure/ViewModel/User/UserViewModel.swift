//
//  UserViewModel.swift
//  ProjectStructure
//
//  Created by Krishna Soni on 02/08/19.
//  Copyright © 2019 Krishna Soni. All rights reserved.
//

import Foundation
import UIKit

class UserViewModel {

    var status: KxSwift<Bool> = KxSwift<Bool>(false)
    var name: KxSwift<String?> = KxSwift<String?>(nil)
    var userId: KxSwift<Int> = KxSwift<Int>(0)
    var arrUserId: KxSwift<[Int]> = KxSwift<[Int]>([])
    var image: KxSwift<UIImage?> = KxSwift<UIImage?>(nil)
    
    func login() {
        
        UserServices().login(para: nil)
        
        status.value = !status.value
        name.value = "Krishna"
        userId.value = 15
        arrUserId.value = [15, 10, 12, 2, 3, 4]
        arrUserId.value.append(200)
        image.value = UIImage(named: "45.jpg")
    }
}
