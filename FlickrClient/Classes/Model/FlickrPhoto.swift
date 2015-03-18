//
//  FlickrPhoto.swift
//  FlickrClient
//
//  Created by Igor Kolpachkov on 18.03.15.
//  Copyright (c) 2015 com.xstudio.ikolpachkov. All rights reserved.
//

import Foundation

struct FlickrPhoto
{
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    var photoLink: String
    {
        get
        {
            let link: String = "http://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret).jpg"
            return link
        }
    }
}