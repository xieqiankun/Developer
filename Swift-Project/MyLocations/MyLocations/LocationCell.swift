//
//  LocationCell.swift
//  MyLocations
//
//  Created by 谢乾坤 on 4/18/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageForLocation(location: Location) -> UIImage {
        if location.hasPhoto, let image = location.photoImage {
            return image.resizedImageWithBounds(CGSize(width: 52, height: 52))
        }
        return UIImage()
    }

    func configureForLocation(location: Location) {
        
        if location.locationDescription.isEmpty {
        descriptionLabel.text = "(No Description)"
        } else {
        descriptionLabel.text = location.locationDescription
        }
        if let placemark = location.placemark { var text = ""
            if let s = placemark.subThoroughfare {
                text += s + " "
            }
            if let s = placemark.thoroughfare { text += s + ", "
            }
            if let s = placemark.locality {
                text += s
            }
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
        }
        photoImageView.image = imageForLocation(location)
    }
    
}
