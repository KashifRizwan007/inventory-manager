//
//  ViewController.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 6/26/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideMenu()
    }
    func slideMenu(){
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController()?.rearViewRevealWidth = 280
            
        view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
    }

}

