//
//  UIImageView+activityIndicator.swift
//  FlickrClient
//
//  Created by Igor Kolpachkov on 18.03.15.
//  Copyright (c) 2015 com.xstudio.ikolpachkov. All rights reserved.
//

import Foundation
import ObjectiveC

private var activityIndicatorAssociationKey: UInt8 = 0

extension UIView
{
    var activityIndicator: UIActivityIndicatorView!
    {
        get
        {
            var indicator = objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
            if (indicator == nil)
            {
                indicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50))
                indicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
                objc_setAssociatedObject(self, &activityIndicatorAssociationKey, indicator, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            }
            return indicator
        }
    }
    
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
}
