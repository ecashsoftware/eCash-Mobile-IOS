//
//  HomeViewController.swift
//  eCash
//
//  Created by Terence Williams on 8/7/18.
//  Copyright © 2018 Terence Williams. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let username = UserDefaults.standard.value(forKey: "username") as! String
        userLabel.text = String.init(format: "%@", username)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
