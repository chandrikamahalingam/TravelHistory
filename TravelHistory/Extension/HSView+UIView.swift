//
//  HSView+UIView.swift
//  TravelHistory
//
//  Created by TravelHistory on 05/12/21.
//

import Foundation
import UIKit

extension UIView{
    //MARK: shadow effect
    func elevationEffect(_ radius: CGFloat = 8, shadowOpacity: Float = 0.5) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = shadowOpacity;
        self.layer.cornerRadius = radius
        self.layer.shadowColor = UIColor(white: 0.8, alpha: 1.0).cgColor
    }
    func setCornerRadius(_ radius: CGFloat = 8) {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
}
