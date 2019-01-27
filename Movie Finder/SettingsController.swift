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
    @IBOutlet weak var showBackdropSwitch: UISwitch!
    
    var languages: [Language] = []
    var languageDropDownText: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show current textual language:
        let currentLanguageText = getLanguageText()
        // Sometimes name is not set, only english-name is set, so format it around that:
        if currentLanguageText.name != "" {
            self.textLanguageButton.setTitle("Language (text): " + currentLanguageText.name + " (" + currentLanguageText.english_name + ")", for: .normal)
        }
        else {
            self.textLanguageButton.setTitle("Language (text): " + currentLanguageText.english_name, for: .normal)
        }
        
        // Show current video language:
        let currentLanguageVideo = getLanguageVideo()
        // Sometimes name is not set, only english-name is set, so format it around that:
        if currentLanguageVideo.name != "" {
            self.viodoLanguageButton.setTitle("Language (video): " + currentLanguageVideo.name + " (" + currentLanguageVideo.english_name + ")", for: .normal)
        }
        else {
            self.viodoLanguageButton.setTitle("Language (video): " + currentLanguageVideo.english_name, for: .normal)
        }
        
        showBackdropSwitch.isOn = showBackdrop()        // Set switch to be as the user preferred
        
        // Get languages TMDB use (is not implemented in library, so this we do "manually"):
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
        // Code of dropdown based on the example-code here: https://cocoapods.org/pods/DropDown
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = textLanguageButton // UIView or UIBarButtonItem
        
        // Action triggered on selection (ie. show video)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.textLanguageButton.setTitle("Language (text): " + item, for: .normal)
            setLanguageText(language: self.languages[index])
            }
        
        dropDown.dataSource = languageDropDownText            // Set what shall be shown
        dropDown.show()                                 // Show dropdown.
    }
    
    @IBAction func chooseVideoLanguage(_ sender: Any) {
        // Code of dropdown based on the example-code here: https://cocoapods.org/pods/DropDown
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = viodoLanguageButton // UIView or UIBarButtonItem
        
        // Action triggered on selection (ie. show video)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.viodoLanguageButton.setTitle("Language (video): " + item, for: .normal)
            setLanguageVideo(language: self.languages[index])
        }
        
        dropDown.dataSource = languageDropDownText            // Set what shall be shown
        dropDown.show()
    }
    
    // Called when user change setting on calling backdrop
    @IBAction func changeBackdrop(_ backdropSwitch: UISwitch) {
        setBackdrop(show: backdropSwitch.isOn)
    }
    
}
