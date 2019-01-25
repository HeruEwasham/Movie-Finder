//
//  function.swift
//  Movie Finder
//
//  Created by Yngve Hestem on 25/01/2019.
//  Copyright © 2019 Yngve Hestem. All rights reserved.
//

import Foundation
import TMDBSwift
import UIKit


// Function based on code from: https://stackoverflow.com/questions/39813497/swift-3-display-image-from-url/46788201
func getImage(imagePath: String, completionHandler: @escaping (UIImage?) -> ()) {
    let pictureUrl = URL(string: "https://image.tmdb.org/t/p/w500" + imagePath)! // We can force unwrap because we are 100% certain the constructor will not return nil in this case.
    
    // Creating a session object with the default configuration.
    // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
    let session = URLSession(configuration: .default)
    
    // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
    let downloadPicTask = session.dataTask(with: pictureUrl) { (data, response, error) in
        // The download has finished.
        if let e = error {
            print("Error downloading image: \(e)")
        } else {
            // No errors found.
            // It would be weird if we didn't have a response, so check for that too.
            if let res = response as? HTTPURLResponse {
                print("Downloaded image with response code \(res.statusCode)")
                if let imageData = data {
                    // Finally convert that Data into an image and do what you wish with it.
                    DispatchQueue.main.async { // Must be runned in main thread.
                        completionHandler(UIImage(data: imageData))
                    }
                } else {
                    print("Couldn't get image: Image is nil")
                }
            } else {
                print("Couldn't get response code for some reason")
            }
        }
    }
    downloadPicTask.resume()
}

























func setTMDBApiKey() {
    //TMDBConfig.apikey = "Your API Key"
}
