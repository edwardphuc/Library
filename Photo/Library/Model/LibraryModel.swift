

import Foundation
import Photos
import UIKit
import RealmSwift

struct ImageModel{
    let asset : PHAsset
    var isSelect : Bool
    let image: UIImage
    init(asset: PHAsset, isSelect : Bool, image : UIImage) {
        self.asset = asset
        self.isSelect = isSelect
        self.image = image
    }
}
struct AlbumModel{
    let name: String
    let count: Int
    let numberofselect : Int
    let collection: PHAssetCollection
    let firstImage: UIImage
    init( name:String, count:Int, collection: PHAssetCollection, firstimage:UIImage, numberofselect: Int ) {
        self.name = name
        self.count = count
        self.collection = collection
        self.firstImage = firstimage
        self.numberofselect = numberofselect
    }
}

@objcMembers class RealmImage : Object{
    dynamic var id  = UUID().uuidString
    dynamic var image : ImageModel?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
/// tao mo realm
