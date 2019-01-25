//
//  ViewController.swift
//  Movie Finder
//
//  Created by Yngve Hestem on 25/01/2019.
//  Copyright © 2019 Yngve Hestem. All rights reserved.
//

import UIKit

import TMDBSwift

class MovieListTableViewController: UITableViewController {

    // MARK: Variables:
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [MovieMDB] = []
    
    //MARK: Code:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Hello")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "showProgram") {
            let secondViewController = segue.destination as! ShowProgramInfoController
            let index = sender as! IndexPath
            secondViewController.program = programs[index.row]
        }
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMovie", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        cell.movie = movies[indexPath.row]
        
        cell.layoutSubviews()
        return cell
    }


}

