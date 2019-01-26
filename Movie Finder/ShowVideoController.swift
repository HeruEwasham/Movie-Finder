//
//  showVideoController.swift
//  Movie Finder
//
//  Created by Yngve Hestem on 26/01/2019.
//  Copyright © 2019 Yngve Hestem. All rights reserved.
//
// Found how to show youtube video here: https://medium.com/@anthonysaltarelli_10509/how-to-embed-youtube-videos-in-an-ios-app-with-swift-4-3d0b80a5cba6

import Foundation
import UIKit
import YoutubePlayer_in_WKWebView

class ShowVideoController: UIViewController {
    
    @IBOutlet weak var playerView: WKYTPlayerView!
    
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if id != nil {
            playerView.load(withVideoId: id!)
        }
    }
}
