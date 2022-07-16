//
//  UIView.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 14/07/22.
//

import UIKit

extension UIView {
    func addSubViewWithAutolayout(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
}
