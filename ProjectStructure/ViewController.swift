//
//  ViewController.swift
//  ProjectStructure
//
//  Created by mac-0005 on 02/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let viewModel: UserViewModel = UserViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call api here..
        viewModel.login()
    }

    @IBAction func onButton(_ sender: UIButton) {
        viewModel.status.value = !viewModel.status.value
    }
}

