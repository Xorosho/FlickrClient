//
//  FlickrProvider.swift
//  FlickrClient
//
//  Created by Igor Kolpachkov on 18.03.15.
//  Copyright (c) 2015 com.xstudio.ikolpachkov. All rights reserved.
//

import Foundation
import AFNetworking

enum SearchAPIResponse
{
    case Ok([FlickrPhoto])
    case Error(NSError)
}

typealias SearchAPICallback = (SearchAPIResponse) -> ()

let flickrKey: String = "6f159d26d2b96ba2b2d84d441a0ab74c"
//let flickrSecret: String = "5157a5124d676957"

struct FlickrAPIErrors
{
    static let invalidInputParameters = 500
    static let invalidServerResponse = 503
}

class FlickrProvider
{
    
    //MARK: FLICKR API METHODS
    class func searchCorrespondingImagesAPI(serchText: String!, callback: SearchAPICallback!)
    {
        if (serchText == "")
        {
            let invalidSearchText = NSError(domain:"com.flickrProvider.searchCorrespondingImagesAPI", code:FlickrAPIErrors.invalidInputParameters, userInfo:nil)
            callback(SearchAPIResponse.Error(invalidSearchText))
            return
        }
        
        
        println("FlickrProvider. searchCorrespondingImagesAPI. Request with search text \(serchText)")
        let searchAPIURLString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
        var parameters = [
            "api_key": flickrKey,
            "text" : serchText,
            "content_type": 1,
            "sort": "interestingness-asc",
            "per_page": 10,
            "format": "json",
            "nojsoncallback": 1
        ]
        
        let networkManager = AFHTTPRequestOperationManager()
        networkManager.requestSerializer = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions())
        networkManager.responseSerializer = AFJSONResponseSerializer()
        networkManager.GET(searchAPIURLString, parameters: parameters, success:
        {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            var responseData: NSDictionary = responseObject as! NSDictionary
            println("FlickrProvider. searchCorrespondingImagesAPI. Responce data: \(responseData)")
            
            if let statusCode = responseData["stat"] as? String
            {
                if statusCode != "ok"
                {
                    let serverResponseError = NSError(domain:"com.flickrProvider.searchCorrespondingImagesAPI", code:FlickrAPIErrors.invalidServerResponse, userInfo: nil)
                    callback(SearchAPIResponse.Error(serverResponseError))
                    return
                }
            }
            
            let photosContainer = responseData["photos"] as! NSDictionary
            let photosArray = photosContainer["photo"] as! [NSDictionary]
            let flickrPhotos: [FlickrPhoto] = photosArray.map
            {
                photoDictionary in
                
                let photoId = photoDictionary["id"] as? String ?? ""
                let farm = photoDictionary["farm"] as? Int ?? 0
                let secret = photoDictionary["secret"] as? String ?? ""
                let server = photoDictionary["server"] as? String ?? ""
                let title = photoDictionary["title"] as? String ?? ""
                let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                return flickrPhoto
            }
            callback(SearchAPIResponse.Ok(flickrPhotos))

        },
        failure:
        {
            (operation: AFHTTPRequestOperation!, error: NSError!)  -> Void in
            
            let serverResponseError = NSError(domain:"com.flickrProvider.searchCorrespondingImagesAPI", code:FlickrAPIErrors.invalidServerResponse, userInfo: nil)
            callback(SearchAPIResponse.Error(serverResponseError))
        })
    }
}