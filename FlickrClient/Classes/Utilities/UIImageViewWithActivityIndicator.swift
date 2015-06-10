//
//  UIImageViewWithActivityIndicator.swift
//  FlickrClient
//
//  Created by Igor Kolpachkov on 18.03.15.
//  Copyright (c) 2015 com.xstudio.ikolpachkov. All rights reserved.
//

import Foundation
import ObjectiveC

private var activityIndicatorAssociationKey: UInt8 = 0

class UIImageViewWithActivityIndicator : UIImageView
{
    lazy var activityIndicator: UIActivityIndicatorView! =
    {
        var indicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        return indicator
    }()
    
    func startActivityIndicator()
    {
        if (!activityIndicator.isAnimating())
        {
            //let center = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
            //activityIndicator.center = center   // in left-top corrner it looks better
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator()
    {
        if (activityIndicator.isAnimating())
        {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func playBounceAnimation()
    {
        var bounceAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [0.99, 1.01, 1.0]
        bounceAnimation.keyTimes = [0.0, 0.2, 1.0]
        bounceAnimation.duration = 0.3
        self.layer.addAnimation(bounceAnimation, forKey: "bounce")
    }
}
