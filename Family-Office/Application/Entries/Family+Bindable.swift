//
//  Family+Bindeble.swift
//  Family-Office
//
//  Created by Leonardo Durazo on 06/02/18.
//  Copyright © 2018 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit
protocol FamilyBindable: AnyObject {
    var family: Family! {get set}
    var titleLbl: UILabelX! {get}
    var photo: UIImageViewX! {get}
    var selectedPhoto: UIImageViewX! {get}
}
extension FamilyBindable {
    var titleLbl: UILabelX! {return nil}
    var photo: UIImageViewX! {return nil}
    var selectedPhoto: UIImageViewX! {return nil}

    func bind(family: Family) {
        self.family = family
        self.bind()
    }

    func bind() {
        guard let family = family else {
            return
        }
        if let titlelbl = titleLbl {
            titlelbl.text = family.name
        }
        if let photo = photo {
            photo.image = #imageLiteral(resourceName: "family-default")
            photo.cornerRadius = 8
            //photo.image = #imageLiteral(resourceName: "icons8-family")
        }

        if let selectedPhoto  = selectedPhoto {
            selectedPhoto.image = #imageLiteral(resourceName: "check-1")
            selectedPhoto.isHidden = self.family.isSelected ? false : true
        }
    }
}
