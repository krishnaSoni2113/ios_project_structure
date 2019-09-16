//
//  ViewController.swift
//  ProjectStructure
//
//  Created by Krishna Soni on 02/08/19.
//  Copyright © 2019 Krishna Soni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView?
    
    let viewModel: UserViewModel = UserViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .baseAppThemeColor
        
        self.configureObserver()
    }

    // Configure KxSwift Observer
    func configureObserver() {
        
        // This will call when value has change from any where..
        
        viewModel.image.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            self.imgProfile?.image = result
        }
        
        viewModel.status.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            if self.viewModel.status.value {
                print("True === ")
            }else {
                print("False === ")
            }
            
        }
        
        // This will call when value has change from any where..
        viewModel.name.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            print(self.viewModel.name.value ?? "")
        }
        
        // This will call when value has change from any where..
        viewModel.userId.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            print(self.viewModel.userId.value)
        }
        
        viewModel.arrUserId.subscribe { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            
            print(self.viewModel.arrUserId.value)
        }

    }

    @IBAction func onButton(_ sender: UIButton) {
        
        // Call api here..
        viewModel.login()
    }
}

