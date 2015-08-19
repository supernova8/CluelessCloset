//
//  SelfieImageView.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/18/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable

class SelfieImageView: UIImageView {
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
    @IBInspectable var shadowColor: UIColor? {
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
    
    @IBInspectable var opacity: CGFloat = 0  {
        didSet {
            layer.opacity = CFloat(opacity)
            
        }
    }
    
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize  = CGSizeMake(0, 0) {
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
