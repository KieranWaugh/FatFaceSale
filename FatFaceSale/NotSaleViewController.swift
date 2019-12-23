//
//  NotSaleViewController.swift
//  FatFaceSale
//
//  Created by Kieran Waugh on 23/12/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit

class NotSaleViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        
        //navigationController?.popViewController(animated: true)
        //performSegue(withIdentifier: "NotSaleBack", sender: self)
        //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    

}
