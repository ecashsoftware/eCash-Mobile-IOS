//
//  LocationViewController.swift
//  eCash
//
//  Created by Terence Williams on 8/7/18.
//  Copyright © 2018 Terence Williams. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var currentLocation: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //zipcodeField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
