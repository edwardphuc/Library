//
//  DBManager.swift
//  Library
//
//  Created by Edward Lauv on 8/24/20.
//  Copyright © 2020 Edward Lauv. All rights reserved.
//

import Foundation
import RealmSwift
import Photos

class DBManager {
    private var database : Realm
    static let instance = DBManager()
    init() {
        //khoi tao realm
        database = try! Realm()
    }
    
    //get all item in db
    func getDataFromDB() -> Results<RealmImage> {
        let result : Results<RealmImage> = database.objects(RealmImage.self)
        return result
    }
    
    //add item to db
    func addData(object: ImageModel, nameCollection: String) {
        let item = RealmImage()
        item.id = UUID().uuidString
        item.albumId = nameCollection
        item.imageID = object.asset.localIdentifier
        item.creationDate = object.asset.creationDate
        item.pixelwidth = object.asset.pixelWidth
        item.pixelheight = object.asset.pixelHeight
        try! database.write{
            database.add(item)
        }
    }
    
    // get list image from collection
    func getListImageSelectWithCollection(collection: PHAssetCollection, listimageSelect: [RealmImage], completion: ([RealmImage]) -> Void){
        var listImageSelectwithCollection: [RealmImage] = []
        let asset = PHAsset.fetchAssets(in: collection, options: nil)
        for i in 0..<asset.count {
            for item in listimageSelect {
                if item.imageID == asset[i].localIdentifier {
                    listImageSelectwithCollection.append(item)
                }
            }
        }
        completion(listImageSelectwithCollection)
    }
    
    //get list image from list realmimage
    func getUIimage(image : RealmImage, completion: (UIImage) -> Void) {
        var result = UIImage()
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [image.imageID], options: nil)
        result = getUIImage(asset: asset.firstObject!)
        completion(result)
    }
    
    func getUIImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        let requestOptions=PHImageRequestOptions()
        requestOptions.isSynchronous=true
        requestOptions.deliveryMode = .highQualityFormat
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 600.0, height: 600.0), contentMode: .aspectFit, options: requestOptions, resultHandler: {(result, info)->Void in
            guard let imgresult = result else{
                return
            }
             
            image = imgresult
        })
        return image
    }
    
    // delete item in database
    func deleteItemWith(image : ImageModel) {
        let object = database.objects(RealmImage.self).filter("imageID == %@",(image.asset.localIdentifier)).first
        do {
            try database.write {
                database.delete(object!)
            }
        }
        catch{
            print(error)
        }
        
    }
    
    // delete all item in db
    func deleteAll() {
        try! database.write {
            database.deleteAll()
        }
    }
}
