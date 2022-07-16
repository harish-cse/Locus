//
//  ImageDetailViewModel.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 15/07/22.
//

import UIKit

protocol ImageDetailViewModelType {
    var image: UIImage { get }
}

class ImageDetailViewModel: ImageDetailViewModelType {

    let image: UIImage

    init(_ image: UIImage) {
        self.image = image
    }
}
