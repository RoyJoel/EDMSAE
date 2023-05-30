//
//  TMServerViewConfig.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation


class TMServerViewConfig {
    var selectedImage: String
    var unSelectedImage: String
    var selectedTitle: String
    var unselectedTitle: String

    init(selectedImage: String, unSelectedImage: String, selectedTitle: String, unselectedTitle: String) {
        self.selectedImage = selectedImage
        self.unSelectedImage = unSelectedImage
        self.selectedTitle = selectedTitle
        self.unselectedTitle = unselectedTitle
    }
}
