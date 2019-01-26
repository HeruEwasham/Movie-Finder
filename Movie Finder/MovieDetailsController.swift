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
import DropDown

class MovieDetailsController: UIViewController {
    
    // MARK: Variables
    
    var id: Int?
    var movieInfo: MovieDetailedMDB?
    var videosInfo: [VideosMDB] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var productionCompaniesLabel: UILabel!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var hompageButton: UIButton!
    
    
    // MARK: Code
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if id != nil {
            // Get more info than what we got in search (detailed info):
            MovieMDB.movie(movieID: id!, language: getLanguageText().iso_639_1){
                apiReturn, movie in
                if let movie = movie{
                    self.movieInfo = movie                      // Save movie info to view as long as it exist.
                    if movie.title != nil {
                        self.titleLabel.text = movie.title
                    }
                    else {                              // Show empty field if value is nil
                        self.titleLabel.text = ""
                    }
                    
                    if movie.original_title != nil {
                        self.originalTitle.text = movie.original_title
                    }
                    else {                              // Show empty field if value is nil
                        self.originalTitle.text = ""
                    }
                    
                    if movie.overview != nil {
                        self.descLabel.text = movie.overview
                    }
                    else {                              // Show empty field if value is nil
                        self.descLabel.text = ""
                    }
                    
                    if movie.poster_path != nil {
                        getImage(imagePath: movie.poster_path!, completionHandler: {(image) in
                            self.posterImage.image = image
                        })
                    }
                    
                    var genres = ""
                    
                    for i in 0..<movie.genres.count {
                        if i == 0 {
                            genres += "Genres: "
                        }
                        if movie.genres[i].name != nil {
                            // If not first company, add a ", ":
                            if i > 0 {
                                genres += ", "
                            }
                            genres += movie.genres[i].name!
                        }
                    }
                    self.genresLabel.text = genres
                    
                    if movie.release_date != nil {
                        self.releaseDateLabel.text = movie.release_date
                    }
                    else {
                        self.releaseDateLabel.text = ""
                    }
                    
                    var productionCompanies = ""
                    if movie.production_companies != nil {
                        productionCompanies += "Production Companies: "
                        for i in 0..<movie.production_companies!.count {
                            if movie.production_companies![i].name != nil {
                                // If not first company, add a ", ":
                                if i > 0 {
                                    productionCompanies += ", "
                                }
                                productionCompanies += movie.production_companies![i].name!
                            }
                        }
                    }
                    self.productionCompaniesLabel.text = productionCompanies
                    
                    // If movie.video seems to not work, so this is my workaround:
                    MovieMDB.videos(movieID: movie.id, language: getLanguageVideo().iso_639_1){
                        apiReturn, videos in
                        if let videos = videos{
                            if videos.count > 0 {
                                self.videoButton.isEnabled = true
                            }
                            for i in videos {
                                if i.site != nil && i.site! == "YouTube" {    // We only support videos from youtube
                                    self.videosInfo.append(i)
                                }
                            }
                        }
                    }
                    
                    // If movie.hompage exist, and is not empty string, enable button:
                    if movie.homepage != nil && movie.homepage! != "" {
                        self.hompageButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "showVideo") {
            let secondViewController = segue.destination as! ShowVideoController
            let id = sender as! String
            secondViewController.id = id
        }
    }

        
    // Open a dialog to choose a video to show:
    @IBAction func openVideo(_ sender: Any) {
        // Code of dropdown based on the example-code: https://cocoapods.org/pods/DropDown
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = videoButton // UIView or UIBarButtonItem

        // Action triggered on selection (ie. show video)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.performSegue(withIdentifier: "showVideo", sender: self.videosInfo[index].key)
        }
        
        // The list of items to display. Can be changed dynamically
        var dropDownVideos: [String] = []
        for i in self.videosInfo {
            dropDownVideos.append(i.type + ": " + i.name)
        }
        dropDown.dataSource = dropDownVideos            // Set what shall be shown
        dropDown.show()                                 // Show dropdown.
    }
    
    // Open webpage in safari:
    @IBAction func openHompage(_ sender: Any) {
        if movieInfo != nil && movieInfo!.homepage != nil {
            // This code is found here: https://stackoverflow.com/questions/25945324/swift-open-link-in-safari
            guard let url = URL(string: movieInfo!.homepage!) else { return }
            UIApplication.shared.open(url)
        }
    }
    
}
