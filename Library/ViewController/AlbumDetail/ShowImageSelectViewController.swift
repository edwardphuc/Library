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
    
    @IBOutlet weak var collectionView: UICollectionView!
    let realmDB = DBManager.instance
    var image : [RealmImage] = []
    var listUIimage : [UIImage] = []
    var sort: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ALbumDetailCell", bundle: nil), forCellWithReuseIdentifier: "ALbumDetailCell")
    }
    
    @IBAction func sortImage(_ sender: Any) {
        sort = true
        fetchData()
        collectionView.reloadData()
    }
    func fetchData() {
        for item in image {
            realmDB.getUIimage(image: item) { (result) in
                listUIimage.append(result)
            }
        }
    }

}

extension ShowImageSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ALbumDetailCell", for: indexPath) as! ALbumDetailCell
        cell.setImage(image: listUIimage[indexPath.row])
        return cell
    }
}

extension ShowImageSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3*5) / 4
        let height = (collectionView.frame.width - 3*5) / 4
        return CGSize(width: width, height: height)
    }
}
