//
//  ConfigLibrary.swift
//  Library
//
//  Created by Edward Lauv on 8/20/20.
//  Copyright © 2020 Edward Lauv. All rights reserved.
//

import UIKit

class ConfigLibrary: NSObject {
    let defaults = UserDefaults.standard
    var listImage : [String] = []
    func addImageSelect(image: ImageModel) {
        //print(image.asset.burstIdentifier)
        self.getAllImageSelct{ (results) in
            listImage = results
        }
        listImage.append(image.asset.localIdentifier)
    }
    
    func removeImageUnselect(image: ImageModel) {
        self.getAllImageSelct { (results) in
            listImage = results
        }
        if let index = listImage.firstIndex(of: image.asset.localIdentifier) {
            listImage.remove(at: index)
        }
    }
    
    func saveListImageSelect() {
        defaults.set(listImage, forKey: "imageSelect")
    }
    
    func getAllImageSelct(completion: (_ listiamge: [String]) ->Void) {
        //var listimageselect : [String] = []
        guard let value = defaults.stringArray(forKey: "imageSelect") else {
            return
        }
        completion(value)
    }
    
    func removeImageSelect() {
        defaults.removeObject(forKey: "imageSelect")
    }
    
    // phasset id
    // get all select -- > listselect = defaults.object(forKey: "PHUCSELECT") // lay danh sanh da luu
    //         defaults.set(value, forKey: "PHUCSELECT") //  luu xuong
    //listselect add (phasset id)// add id vo danh sach
    // set lai list select --> defaults.set(listselect, forKey: "PHUCSELECT")// luu danh sach xuong
    
}
