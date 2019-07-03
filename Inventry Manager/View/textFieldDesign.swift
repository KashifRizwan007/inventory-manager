//
//  textFieldDesign.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 6/27/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

@IBDesignable class textFieldDesign: UITextField {
    
    var bottomBorder = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        styleTextField()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        styleTextField()
    }
    
    
    func styleTextField() {
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = UIColor.darkGray
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        //Mark: Setup Anchors
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
    }

}
