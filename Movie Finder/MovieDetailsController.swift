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
    var similarMovies: [MovieMDB] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var productionCompaniesLabel: UILabel!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var hompageButton: UIButton!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var productionCountriesLabel: UILabel!
    @IBOutlet weak var showSimilarMoviesButton: UIButton!
    
    
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
                    
                    // Set poster-image:
                    if movie.poster_path != nil {
                        getImage(imagePath: movie.poster_path!, completionHandler: {(image) in
                            self.posterImage.image = image
                        })
                    }
                    
                    // Set backdrop-image if backdrop exist and user will see it:
                    print("Backdrop is shown in details page: " + String(showBackdrop()))
                    if movie.backdrop_path != nil && showBackdrop() {
                        getImage(imagePath: movie.backdrop_path!, completionHandler: {(image) in
                            self.backdropImage.image = image
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
                        self.releaseDateLabel.text = "Release date: " + movie.release_date!
                    }
                    else {
                        self.releaseDateLabel.text = ""
                    }
                    
                    if movie.original_language != nil {
                        self.originalLanguageLabel.text = "Original language: " + movie.original_language!
                    }
                    else {
                        self.originalLanguageLabel.text = ""
                    }
                    
                    if movie.runtime != nil {
                        self.runtimeLabel.text = "Runtime: " + String(movie.runtime!) + " min"
                    }
                    else {
                        self.runtimeLabel.text = ""
                    }
                    
                    var productionCompanies = ""
                    if movie.production_companies != nil {
                        productionCompanies += "Production companies: "
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
                    
                    var productionCountries = ""
                    if movie.production_countries != nil {
                        productionCountries += "Production countries: "
                        for i in 0..<movie.production_countries!.count {
                            if movie.production_countries![i].name != nil {
                                // If not first country, add a ", ":
                                if i > 0 {
                                    productionCountries += ", "
                                }
                                productionCountries += movie.production_countries![i].name!
                            }
                        }
                    }
                    self.productionCountriesLabel.text = productionCountries
                    
                    // movie.video seems to not work, so this is my workaround:
                    MovieMDB.videos(movieID: movie.id, language: getLanguageVideo().iso_639_1){
                        apiReturn, videos in
                        // if videos returned, enable button and add to variable in the view.
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
                    
                    // Get similar movies
                    MovieMDB.similar(movieID: self.id, page: 1, language: getLanguageText().iso_639_1){
                        data, relatedMovies in
                        // if movies returned, enable button and add to variable in the view.
                        if let movie = relatedMovies{
                            if movie.count > 0 {
                                self.showSimilarMoviesButton.isEnabled = true
                            }
                            for i in movie {
                                self.similarMovies.append(i)
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
        else if (segue.identifier == "showSimilarMovies") {
            let secondViewController = segue.destination as! MovieDetailsController
            let id = sender as! Int
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
    
    @IBAction func showSimilarMovies(_ sender: Any) {
        // Code of dropdown based on the example-code: https://cocoapods.org/pods/DropDown
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = videoButton // UIView or UIBarButtonItem
        
        // Action triggered on selection (ie. show info about other movie)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let similarMovieController = storyBoard.instantiateViewController(withIdentifier: "movieDetailsController") as! MovieDetailsController
            similarMovieController.id = self.similarMovies[index].id
            self.navigationController!.pushViewController(similarMovieController, animated: true)
        }
        
        // The list of items to display. Can be changed dynamically
        var dropDownSimilarMovies: [String] = []
        for i in self.similarMovies {
            // If release date exist, add it to the text.
            if i.release_date != nil && i.release_date != "" {
                // Get year from the release date:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-mm-dd" // Date format
                //according to date format your date string
                guard let date = dateFormatter.date(from: i.release_date!) else {
                    fatalError()                    // The format should be correct.
                }
                
                // Gotten from: https://coderwall.com/p/b8pz5q/swift-4-current-year-mont-day
                let calendar = Calendar.current
                dropDownSimilarMovies.append(i.title! + " (" + String(calendar.component(.year, from: date)) + ")")
            }
            else {                                            // If release date is not provided, only add title.
                dropDownSimilarMovies.append(i.title!)
            }
        }
        dropDown.dataSource = dropDownSimilarMovies            // Set what shall be shown
        dropDown.show()                                        // Show dropdown.
    }
}
