//
//  UIView+animations.swift
//  FlickrClient
//
//  Created by Igor Kolpachkov on 18.03.15.
//  Copyright (c) 2015 com.xstudio.ikolpachkov. All rights reserved.
//

import Foundation


extension UIView
{
    func playBounceAnimation()
    {
        var bounceAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [0.99, 1.01, 1.0]
        bounceAnimation.keyTimes = [0.0, 0.2, 1.0]
        bounceAnimation.duration = 0.3
        self.layer.addAnimation(bounceAnimation, forKey: "bounce")
    }
}