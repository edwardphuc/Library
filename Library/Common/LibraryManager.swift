
import UIKit
import Photos

@available(iOS 13.0, *)
class LibraryManager: NSObject {
    //MARK: function hanlder album
    func getListAlbum(compleion:(_ listAlbum: NSArray)->Void){
        var listalbum : [AlbumModel] = []
        let options = PHFetchOptions()
        let useralbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options)
        let usersmartalbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options)
        
        useralbum.enumerateObjects({(collection, int, stop) in
            let albumoption = PHFetchOptions()
            albumoption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let assetuseralbum = PHAsset.fetchAssets(in: collection, options: albumoption)
            if assetuseralbum.count > 0{
                let album = AlbumModel(name: collection.localizedTitle ?? "", count: assetuseralbum.count, collection: collection, firstimage: self.getFirstImage(collection: collection), numberofselect: self.checkImageSelect(collection: collection))
                listalbum.append(album)
            }
        })
        
        usersmartalbum.enumerateObjects({(collection, int, stop) in
            let albumoption = PHFetchOptions()
            let asset = PHAsset.fetchAssets(in: collection, options: albumoption)
            if asset.count>0{
                let album = AlbumModel(name: collection.localizedTitle ?? "", count: asset.count, collection: collection, firstimage: self.getFirstImage(collection: collection), numberofselect: self.checkImageSelect(collection: collection))
                listalbum.append(album)
            }
        })
        compleion(listalbum as NSArray)
    }
    func getFirstImage(collection: PHAssetCollection) -> UIImage {
        var img = UIImage()
        let assetoption = PHFetchOptions()
        //assetoption.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let asset = PHAsset.fetchAssets(in: collection, options: assetoption)
        img = getUIImage(asset: asset.firstObject!)
        return img
    }
    // MARK: count number image select
    func checkImageSelect(collection: PHAssetCollection) -> Int {
        var count : Int = 0
        var idImageSelect : [String] = []
        let config = ConfigLibrary()
        config.getAllImageSelct{ (result) in
            for item in result {
                idImageSelect.append(item)
            }
        }
        let asset = PHAsset.fetchAssets(in: collection, options: nil)
        if idImageSelect.count > 0 {
            for i in 0..<asset.count {
                for item in idImageSelect {
                    if item == asset[i].localIdentifier {
                        count+=1
                    }
                }
            }
        }
        return count
    }
    
    //MARK: function hanlder list image
    func getListImageFromCollection(collection: AlbumModel, completion:(_ listimage: Array<ImageModel>)->Void){
        var listImag : [ImageModel] = []
        let assetoption = PHFetchOptions()
        assetoption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let asset = PHAsset.fetchAssets(in: collection.collection, options: assetoption)
        if asset.count > 0 {
            asset.enumerateObjects{(object, int, stop) in
                let objectimage = ImageModel(asset: object, isSelect: self.checkImageIsSelectBefore(asset: object), image: self.getUIImage(asset: object))
                listImag.append(objectimage)
            }
        }
        completion(listImag)
    }
    
    func checkImageIsSelectBefore(asset: PHAsset) -> Bool{
        var isSelectBefore : Bool = false
        let config = ConfigLibrary()
        config.getAllImageSelct { (results) in
            for item in results {
                if item == asset.localIdentifier {
                    isSelectBefore = true
                }
            }
        }
        return isSelectBefore
    }
    
    //MARK: func support
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
    
}
