//
//  SettingsController.swift
//  Movie Finder
//
//  Created by Yngve Hestem on 26/01/2019.
//  Copyright © 2019 Yngve Hestem. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class SettingsController: UIViewController {
    
    
    @IBOutlet weak var textLanguageButton: UIButton!
    @IBOutlet weak var viodoLanguageButton: UIButton!
    
    var languages: [Language] = []
    var languageDropDownText: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HTTPGetJSON(url: "https://api.themoviedb.org/3/configuration/languages?api_key=" + apiKeyTMDB()) { (err, result) in
            if(err != nil){
                print(err!.localizedDescription)
                return
            }
            
            do {
                // Decode language json to language objects:
                let jsonDecoder = JSONDecoder()
                self.languages = try jsonDecoder.decode([Language].self, from: result!)
                
                // Make a textual description for all languages:
                for i in self.languages {
                    // Sometimes name is not set, only english-name is set, so format it around that:
                    if i.name != "" {
                        self.languageDropDownText.append(i.name + " (" + i.english_name + ")")
                    }
                    else {
                        self.languageDropDownText.append(i.english_name)
                    }
                    
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func chooseTextLanguage(_ sender: Any) {
        // Code of dropdown based on the example-code: https://cocoapods.org/pods/DropDown
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = textLanguageButton // UIView or UIBarButtonItem
        
        // Action triggered on selection (ie. show video)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.textLanguageButton.titleLabel!.text = "Language (text): " + item
            // Decode language json to language object:
            let data = try JSONEncoder().encode(self.languages[index])
            UserDefaults.standard.set(data, forKey: "textLanguage")     // Save new userdefault
            } as? SelectionClosure
        
        dropDown.dataSource = languageDropDownText            // Set what shall be shown
        dropDown.show()                                 // Show dropdown.
    }
    
    @IBAction func chooseVideoLanguage(_ sender: Any) {
        
    }
    
}
