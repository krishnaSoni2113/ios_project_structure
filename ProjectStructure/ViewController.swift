//
//  ViewController.swift
//  ProjectStructure
//
//  Created by mac-0005 on 02/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView?
    
    let viewModel: UserViewModel = UserViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .baseAppThemeColor
        
        // Call api here..
        self.configureImage()
        viewModel.login()
        
    }
    
    func configureImage() {
        viewModel.image.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            self.imgProfile?.image = result
        }

    }

    @IBAction func onButton(_ sender: UIButton) {
        viewModel.status.value = !viewModel.status.value
        viewModel.name.value = "Krishna"
        viewModel.userId.value = 15
        viewModel.arrUserId.value = [15, 10, 12, 2, 3, 4]
        viewModel.arrUserId.value.append(200)
        viewModel.image.value = UIImage(named: "45.jpg")
        
    }
}

