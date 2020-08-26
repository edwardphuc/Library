//
//  AlbumDetailViewController.swift
//  Library
//
//  Created by Edward Lauv on 8/19/20.
//  Copyright © 2020 Edward Lauv. All rights reserved.
//

import UIKit
protocol AlbumDetailViewControllerDelegate {
    func reload()
}


@available(iOS 13.0, *)
class AlbumDetailViewController: UIViewController {

    @IBOutlet weak var btNext: UIButton!
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var btSelect: UIButton!
    var album  : AlbumModel?
    var listImage : [ImageModel] = []
    var clickChoose: Bool = false
    @IBOutlet weak var collectionView: UICollectionView!
    let activity = UIActivityIndicatorView(frame: UIScreen.main.bounds)
    var listImageSelect = ConfigLibrary()
    var delegate : AlbumDetailViewControllerDelegate?
    var realmDB = DBManager.instance
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activity.startAnimating()
        self.view.addSubview(self.activity)
        setupUI()
        fetchData()
    }
    
    @IBAction func clickdown(_ sender: Any) {
        if clickChoose == false {
            listImageSelect.removeImageSelect()
            btSelect.setTitle( "Cancel", for: .normal)
            clickChoose = true
            btNext.isHidden = false
        }
        else {
            btSelect.setTitle( "Choose", for: .normal)
            clickChoose = false
//            for i in 0..<listImage.count {
//                listImage[i].isSelect = false
//            }
            
            btNext.isHidden = true
            checkImageUnselect()
            self.collectionView.reloadData()
        }
    }
    
    func checkImageUnselect() {
        for i in 0..<listImage.count {
            if listImage[i].isSelect == true {
                listImageSelect.removeImageUnselect(image: listImage[i])
                listImage[i].isSelect = false
                listImageSelect.saveListImageSelect()
                realmDB.deleteItemWith(image: listImage[i])
            }
        }
    }
    
    // click button next show image select
    @IBAction func clickDown(_ sender: Any) {
        let screenShowImage = ShowImageSelectViewController()
        let imageFromDB = realmDB.getDataFromDB()
        var listImageSelect : [RealmImage] = []
        //var listImageSelectinCollection : [RealmImage] = []
        for item in imageFromDB {
            listImageSelect.append(item)
        }
        realmDB.getListImageSelectWithCollection(collection: album!.collection, listimageSelect: listImageSelect) { (results) in
            for item in results {
                screenShowImage.image.append(item)
            }
        }
        self.present(screenShowImage, animated: true)
    }
    
    func setupUI() {
        self.title = album?.collection.localizedTitle
        lblTittle.text = album?.collection.localizedTitle
        btSelect.layer.cornerRadius = 5
        btNext.layer.cornerRadius = 5
        btNext.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ALbumDetailCell", bundle: nil), forCellWithReuseIdentifier: "ALbumDetailCell")
        checkButtonChoose()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(Back))
    }
    
    @objc func Back() {
        self.dismiss(animated: true)
    }
    
    func checkButtonChoose() {
        listImageSelect.getAllImageSelct{ (results) in
            if results.count > 0 {
                btSelect.setTitle( "Cancel", for: .normal)
                clickChoose = true
                btNext.isHidden = false
            }
        }
    }
    
    func fetchData() {
        let dispatch = DispatchQueue(label: "fetchdata")
        let manager = LibraryManager()
        dispatch.async {
            manager.getListImageFromCollection(collection: self.album!, completion: {(result) in
                for item in result {
                    self.listImage.append(item)
                    DispatchQueue.main.async {
                        self.activity.stopAnimating()
                        self.collectionView.reloadData()
                    }
                }
            })
        }
    }
    
    @IBAction func Exit(_ sender: Any) {
        delegate?.reload()
        self.dismiss(animated: true)
    }
}

@available(iOS 13.0, *)
extension AlbumDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ALbumDetailCell", for: indexPath) as! ALbumDetailCell
        cell.setupUI(image: listImage[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if clickChoose == true {
            let cell = collectionView.cellForItem(at: indexPath) as! ALbumDetailCell
            if cell.tick.isHidden == true {
                cell.tick.isHidden = false
                listImage[indexPath.row].isSelect = true
                listImageSelect.addImageSelect(image: listImage[indexPath.row])
                realmDB.addData(object: listImage[indexPath.row], nameCollection: (album?.collection.localIdentifier)!)
            }
            else {
                cell.tick.isHidden = true
                listImage[indexPath.row].isSelect = false
                listImageSelect.removeImageUnselect(image: listImage[indexPath.row])
                realmDB.deleteItemWith(image: listImage[indexPath.row])
            }
            print(indexPath.row)
            listImageSelect.saveListImageSelect()
        }
    }
    
}

@available(iOS 13.0, *)
extension AlbumDetailViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (collectionView.frame.width - 3*5) / 4
        let width = (collectionView.frame.width - 3*5) / 4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
