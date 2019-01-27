//
//  MovieFeaturedListController.swift
//  Movie Finder
//
//  Created by Yngve Hestem on 27/01/2019.
//  Copyright © 2019 Yngve Hestem. All rights reserved.
//

import Foundation


import UIKit

import TMDBSwift

class MovieFeaturedListController: UITableViewController {
    
    // MARK: Variables:
    
    var movies: [MovieMDB] = []
    
    //MARK: Code:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TMDBConfig.apikey = apiKeyTMDB()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get featured movies:
        DiscoverMDB.discover(discoverType: .movie, language: getLanguageText().iso_639_1, page: 1){
            data, movie, tv in
            if let discoveredMovies = movie{
                self.movies = discoveredMovies      // Save to variable that can be acessed by tableview
                self.tableView.reloadData()         // Reload tableview
            }
        }
    }
    
    
    // MARK: TableView-code
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "showMovieDetails") {
            let secondViewController = segue.destination as! MovieDetailsController
            let index = sender as! IndexPath
            secondViewController.id = movies[index.row].id
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMovieDetails", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MovieCellFeatured") as! MovieFeaturedCell
        cell.movie = movies[indexPath.row]
        
        cell.layoutSubviews()
        return cell
    }
    
    
}

