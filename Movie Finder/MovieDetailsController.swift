//
//  MovieDetails.swift
//  Movie Finder
//
//  Created by Yngve Hestem on 25/01/2019.
//  Copyright © 2019 Yngve Hestem. All rights reserved.
//

import Foundation
import UIKit
import TMDBSwift

class MovieDetailsController: UIViewController {
    
    // MARK: Variables
    
    var movie: MovieMDB?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var genresLabel: UILabel!
    
    
    // MARK: Code
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if movie != nil {
            if movie!.title != nil {
                titleLabel.text = movie!.title
            }
            else {                              // Show empty field if value is nil
                titleLabel.text = ""
            }
            
            if movie!.original_title != nil {
                originalTitle.text = movie!.original_title
            }
            else {                              // Show empty field if value is nil
                originalTitle.text = ""
            }
            
            if movie!.overview != nil {
                descLabel.text = movie!.overview
            }
            else {                              // Show empty field if value is nil
                descLabel.text = ""
            }
            
            if movie!.poster_path != nil {
                getImage(imagePath: movie!.poster_path!, completionHandler: {(image) in
                    self.posterImage.image = image
                })
            }
        }
    }
    
}
