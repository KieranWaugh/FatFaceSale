//
//  InSaleViewController.swift
//  FatFaceSale
//
//  Created by Kieran Waugh on 23/12/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit

class InSaleViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var saleLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var newPrice: UILabel!
    @IBOutlet weak var department: UILabel!
    var sale = false
    var item : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("item is \(item)")
        if sale{
            imageView.image = .checkmark
            saleLabel.text = "In Sale"
            productName.text = "Product Name: \(item[4])"
            originalPrice.text = "Original Price: \(item[7])"
            newPrice.text = "New Price: \(item[8])"
            department.text = "Department: \(item[1])"
        }else{
            imageView.image = .remove
            saleLabel.text = "Not in Sale"
        }
        
        // Do any additional setup after loading the view.
    }
    
   
    

}
