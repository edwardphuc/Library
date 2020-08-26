//
//  HomeViewController.swift
//  Library
//
//  Created by Edward Lauv on 8/26/20.
//  Copyright © 2020 Edward Lauv. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var viewWorldwide: UIView!
    @IBOutlet weak var viewComfirmed: UIView!
    @IBOutlet weak var viewRecovered: UIView!
    @IBOutlet weak var viewDeaths: UIView!
    @IBOutlet weak var lblconfirmed: UILabel!
    @IBOutlet weak var lblrecovered: UILabel!
    @IBOutlet weak var lbldeaths: UILabel!
    @IBOutlet weak var viewMask: UIView!
    @IBOutlet weak var viewWashHand: UIView!
    @IBOutlet weak var viewChecking: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    func setupUI() {
        viewChecking.layer.cornerRadius = 20
        viewMask.layer.cornerRadius = 20
        viewWashHand.layer.cornerRadius = 20
        viewWorldwide.layer.cornerRadius = 10
        viewDeaths.layer.cornerRadius = 10
        viewComfirmed.layer.cornerRadius = 10
        viewRecovered.layer.cornerRadius = 10
    }
    
    func fetchData(){
        ManagerNetworking.instance.fectdatawithcoutry(urlcountry: "World", Completion: { (results) in
            guard let data: CountriesInfo = results else {return}
            self.lblconfirmed.text = String(describing: data.cases!)
            self.lblrecovered.text = String(describing: data.recovered!)
            self.lbldeaths.text = String(describing: data.deaths!)
            
        })
//        lblconfirmed.text = String(worldInfo!.cases!)
//        lblrecovered.text = String(worldInfo!.recovered!)
//        lbldeaths.text = String(worldInfo!.deaths!)

    }
}
