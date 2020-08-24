//
//  AlbumCell.swift
//  Library
//
//  Created by Edward Lauv on 8/19/20.
//  Copyright © 2020 Edward Lauv. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var lblnumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI(album: AlbumModel) {
        imgView.image = album.firstImage
        lblTittle.text = album.name
        if album.numberofselect == 0 {
            lblnumber.text = "(" + String(album.count) + ")"
        }
        else {
            lblnumber.text = "(" + String(album.numberofselect) + "/" + String(album.count) + ")"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
