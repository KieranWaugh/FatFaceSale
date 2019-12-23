//
//  SharedData.swift
//  FatFaceSale
//
//  Created by Kieran Waugh on 23/12/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import Foundation

class sharedData{
    static let shared = sharedData()
    
    var csvData : [[String : String]] = []
    var csvRows : [[String]] = []
    
}
