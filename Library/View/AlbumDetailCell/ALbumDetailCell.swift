//
//  ALbumDetailCell.swift
//  Library
//
//  Created by Edward Lauv on 8/19/20.
//  Copyright © 2020 Edward Lauv. All rights reserved.
//

import UIKit

class ALbumDetailCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tick: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI(image: ImageModel){
        imgView.image = image.image
        if image.isSelect == true {
            tick.isHidden = false
        }
        else
        {
            tick.isHidden = true
        }
    }
}
