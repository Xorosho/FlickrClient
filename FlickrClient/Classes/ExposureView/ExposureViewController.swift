//
//  ViewController.swift
//  FlickrClient
//
//  Created by Igor Kolpachkov on 17.03.15.
//  Copyright (c) 2015 com.xstudio.ikolpachkov. All rights reserved.
//

import UIKit

class ExposureViewController: UIViewController, UISearchBarDelegate
{
    var exposureView: ExposureView?
    var previousSearchText: String?
    var photosArray: [FlickrPhoto]?
    
    override func loadView()
    {
        super.loadView()
        exposureView = ExposureView.loadFromNibNamed("ExposureView") as? ExposureView
        self.view = exposureView
        
        exposureView?.setupViewElements()
        exposureView?.searchBar.delegate = self
        
        exposureView?.showNextLoadedPhotoControl?.addTarget(self, action:"showNextPhoto", forControlEvents:UIControlEvents.TouchUpInside)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
// MARK: ACTIONS METHODS
    func showNextPhoto()
    {
        if (exposureView!.searchBar.isFirstResponder())
        {
            exposureView!.searchBar.resignFirstResponder()
        }
        else
        {
            showRandomPhoto()
        }
    }
    
// MARK: EXPOSURE IMAGE VIEW METHODS
    func showImageWithLink(link: String!)
    {
        println("ExposureViewController. showImageWithLink. Start load image with link \(link)")

        exposureView?.flickrImageView.startActivityIndicator()
        let url: NSURL = NSURL(string: link)!;
        exposureView?.flickrImageView.setImageWithUrlRequest(url, placeHolderImage: nil, success:
        {
            (request:NSURLRequest?, response:NSURLResponse?, image:UIImage) -> Void in
            self.exposureView?.flickrImageView.stopActivityIndicator()
            self.changeFlickrImage(image)
        },
        failure:
        {
            (request:NSURLRequest?, response:NSURLResponse?, error:NSError?) -> Void in
            self.exposureView?.flickrImageView.stopActivityIndicator()
            self.showInformationAlert("Error. Coudn't download image. Description: \(error?.description)")
        })
    }
    
    func changeFlickrImage(image: UIImage?)
    {
        if (image == nil)
        {
            showInformationAlert("Where is no photo for this request")
            return
        }
        
        let imageSize: CGSize = image!.size
        let newFlickrImageViewRect = exposureView!.calculateFlickrImageViewRect(imageSize:imageSize)
        exposureView!.flickrImageView.image = image
        exposureView!.flickrImageView.frame = newFlickrImageViewRect
        exposureView!.flickrImageView.playBounceAnimation()
    }
    
    func showInformationAlert(text: String!)
    {
        var alert = UIAlertView(title: "Information", message: text, delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
// MARK: SEARCH BAR DELEGATE METHODS    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        exposureView!.searchBar.resignFirstResponder()
        let searchText = searchBar.text
        if (searchText != "" && searchText != previousSearchText)
        {
            previousSearchText = searchText
            FlickrProvider.searchCorrespondingImagesAPI(searchText, callback:searchCorrespondingImagesAPIHandler)
        }
    }
    
//MARK: FLICKR PROVIDER HANDLERS
    func searchCorrespondingImagesAPIHandler(photosData: [FlickrPhoto]?, error: NSError?)
    {
        if (error != nil)
        {
            showInformationAlert(error!.description)
            return
        }
        
        photosArray = photosData
        showRandomPhoto()
    }
    
    func showRandomPhoto()
    {
        var photosCount: Int? = photosArray?.count
        if (photosCount == nil || photosCount == 0)
        {
            showInformationAlert("Where is no photo to show")
            return
        }
        
        let count = UInt32(photosArray!.count)
        let randomIndex = Int(arc4random_uniform(count))
        let photoData: FlickrPhoto! = photosArray![randomIndex]
        let photoLink: String = photoData.photoLink
        showImageWithLink(photoLink)
        
        //remove used photo
        photosArray!.removeAtIndex(randomIndex)
    }
}



