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
    @IBOutlet weak var ReleaseDateLabel: UILabel!
    
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
        else {
            titleLabel.text = ""
        }
        
        if (movie != nil && movie!.release_date != nil && movie!.release_date! != "") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd" // Date format
            //according to date format your date string
            guard let date = dateFormatter.date(from: movie!.release_date!) else {
                fatalError()                    // The format should be correct.
            }
            
            // Gotten from: https://coderwall.com/p/b8pz5q/swift-4-current-year-mont-day
            let calendar = Calendar.current
            ReleaseDateLabel.text = String(calendar.component(.year, from: date))
        }
        else {
            ReleaseDateLabel.text = ""
        }
    }
}
