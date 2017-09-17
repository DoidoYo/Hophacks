//
//  UnderlinedTextField.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/31/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class UnderlinedTextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        var rect = super.rightViewRect(forBounds: bounds)
        
        rect.origin.x += rightPadding
        
        return rect
    }

    @IBInspectable var underlineColor: UIColor?{
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    
    @IBInspectable var imageColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += rightPadding
        
        return rect
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += rightPadding
        
        return rect
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += rightPadding
        
        return rect
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = imageColor
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSForegroundColorAttributeName: imageColor])
        
        
        let border = CALayer()
        let width = CGFloat(2)
        
        border.borderColor = underlineColor?.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: self.frame.size.width + leftView!.frame.width, height: self.frame.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
