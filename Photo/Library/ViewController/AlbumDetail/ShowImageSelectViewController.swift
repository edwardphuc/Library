//
//  ShowImageSelectViewController.swift
//  Library
//
//  Created by Edward Lauv on 8/24/20.
//  Copyright © 2020 Edward Lauv. All rights reserved.
//

import UIKit
import RealmSwift

class ShowImageSelectViewController: UIViewController {
    
    let realmDB = DBManager()
    var imageSelect : Results<RealmImage>?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
    }
    
    func fetchData() {
        imageSelect = realmDB.getDataFromDB()
        for i in 0..<imageSelect!.count {
            
        }
    }

}
