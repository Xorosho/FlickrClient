//
//  ExposureView.swift
//  FlickrClient
//
//  Created by Igor Kolpachkov on 17.03.15.
//  Copyright (c) 2015 com.xstudio.ikolpachkov. All rights reserved.
//

import UIKit

class ExposureView: UIView
{
    @IBOutlet weak var searchBar: UISearchBar!
    var flickrImageView: UIImageView! = UIImageView()
    var showNextLoadedPhotoControl: UIControl?
    
    func setupViewElements()
    {
        customizeSearchBar()
        
        flickrImageView.frame = UIScreen.mainScreen().bounds
        self.addSubview(flickrImageView);
        
        showNextLoadedPhotoControl = UIControl(frame:maxAllowedFlickrImageViewRect())
        self.addSubview(showNextLoadedPhotoControl!)
    }
    
    func customizeSearchBar()
    {
        searchBar.backgroundImage = UIImage()
        searchBar.scopeBarBackgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.translucent = true
        searchBar.placeholder = "Type title, description or photo name"
    }
    
    override func layoutSubviews()
    {
        let maxRect = maxAllowedFlickrImageViewRect()
        showNextLoadedPhotoControl?.frame = maxRect
        if (flickrImageView.image != nil)
        {
            let imageSize:CGSize = flickrImageView.image!.size
            flickrImageView.frame = calculateFlickrImageViewRect(imageSize:imageSize)
        }
        else
        {
            flickrImageView.frame = maxRect
        }
    }
    
    let borderSpace: CGFloat = 8.0
    private func maxAllowedFlickrImageViewRect() -> CGRect
    {
        let viewFrame = self.frame
        let topOffset = searchBar.frame.origin.y + searchBar.frame.size.height + borderSpace
        let width = viewFrame.size.width - 2 * borderSpace
        let height = viewFrame.size.height - topOffset - borderSpace
        var rect = CGRect(x:borderSpace, y:topOffset, width:width, height:height)
        return rect
    }
    
    func calculateFlickrImageViewRect(imageSize imgSize: CGSize!) -> CGRect
    {
        let imageWidth = imgSize.width
        let imageHeight = imgSize.height
        let maxAllowedRect: CGRect = maxAllowedFlickrImageViewRect()
        
        let widthCoefficient =  imageWidth/maxAllowedRect.size.width
        let heightCoefficient = imageHeight/maxAllowedRect.size.height
        
        var width = min(imageWidth, maxAllowedRect.size.width)
        var height = width * imageHeight / imageWidth
        if (widthCoefficient < heightCoefficient)
        {
            height = min(imageHeight, maxAllowedRect.size.height)
            width = height * imageWidth / imageHeight
        }
        
        let topOffset = maxAllowedRect.origin.y + (maxAllowedRect.size.height - height)/2.0
        let rightOffset = maxAllowedRect.origin.x + (maxAllowedRect.size.width - width)/2.0
        
        var rect = CGRect(x:rightOffset, y:topOffset, width:width, height:height)
        return rect
    }
}
