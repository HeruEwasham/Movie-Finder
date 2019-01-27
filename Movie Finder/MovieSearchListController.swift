//
//  MovieSearchListController.swift
//  Movie Finder
//
//  Created by Yngve Hestem on 25/01/2019.
//  Copyright © 2019 Yngve Hestem. All rights reserved.
//

import UIKit

import TMDBSwift

class MovieSearchListController: UITableViewController, UISearchBarDelegate {

    // MARK: Variables:
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive: Bool = false
    var movies: [MovieMDB] = []
    
    //MARK: Code:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TMDBConfig.apikey = apiKeyTMDB()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
    }
    
    
    // MARK: SearchBar-code
    // Tutorial for search bar: https://shrikar.com/swift-ios-tutorial-uisearchbar-and-uisearchbardelegate/
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    // Search for every inputted character:
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        SearchMDB.movie(query: searchText, language: getLanguageText().iso_639_1, page: 1, includeAdult: true, year: nil, primaryReleaseYear: nil){
            data, movies in
            if (movies != nil) {
                if(movies!.count == 0){
                    self.searchActive = false;
                } else {
                    self.searchActive = true;
                }
                self.movies = movies!
                self.tableView.reloadData()
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieSearchCell
        cell.movie = movies[indexPath.row]
        
        cell.layoutSubviews()
        return cell
    }


}

