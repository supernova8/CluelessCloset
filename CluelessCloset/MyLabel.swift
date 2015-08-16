//
//  MyLabel.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/15/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit

@IBDesignable
class MyLabel: UILabel {
    
    //MARK: -
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
        
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
            
        }
    }
    /// The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
    @IBInspectable override var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.CGColor
            
        }
    }
    
    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable var shadowOpacity: CGFloat = 0  {
        didSet {
            layer.shadowOpacity = CFloat(shadowOpacity)
            
        }
    }
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable override var shadowOffset: CGSize {
        didSet {
            layer.shadowOffset = shadowOffset
            
        }
    }
    
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
            
        }
    }
    
}
