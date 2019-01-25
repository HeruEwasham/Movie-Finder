//
//  MovieCell.swift
//  Movie Finder
//
//  Created by Yngve Hestem on 25/01/2019.
//  Copyright © 2019 Yngve Hestem. All rights reserved.
//

import Foundation

import TMDBSwift

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var movie: MovieMDB?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (movie != nil && movie!.title != nil) {
            titleLabel.text = movie!.title
        }
        
    }
}
