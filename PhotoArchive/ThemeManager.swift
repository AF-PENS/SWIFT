//
//  ThemeManager.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 5/3/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

struct ThemeManager {

    
    
    
    static func applyTheme(theme: Int) {
        
        switch theme {
        // Apply default theme
        case 0:
            defaultTheme()
        case 1:
            InvaderGreenTheme()
        case 2:
            EnvyTheme()
        default:
            defaultTheme()
        }
    }
    
    static func applyBackground(theme: Int) -> UIColor {
        
        switch theme {
        case 0:
            return defaultBackground()
        case 1:
            return InvaderGreenBackground()
        case 2:
            return EnvyBackground()
        default:
            return defaultBackground()
        }
    }
    
    static func applyCellOutline(theme: Int) -> CGColor {
        
        switch theme {
        case 0:
            return defaultCellOutline()
        case 1:
            return InvaderGreenCellOutline()
        case 2:
            return EnvyCellOutline()
        default:
            return defaultCellOutline()
        }
    }
    
    static func defaultTheme() {
        
        // Colors
        let darkBlue = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        
        // Status bar
        UIApplication.shared.statusBarStyle = .default
        
        // Navigaton bar
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.blue
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        
        // Tab bar
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.blue
        
        // Background colors
        UILabel.appearance().backgroundColor = UIColor.clear
        UITextField.appearance().backgroundColor = UIColor.white
        UICollectionView.appearance().backgroundColor = UIColor.white
        UITextView.appearance().backgroundColor = UIColor.white
        
        // Page headers
        HeaderLabel.appearance().backgroundColor = darkBlue
        
        // Text
        UITextField.appearance().textColor = UIColor.black
        UITextView.appearance().textColor = UIColor.black
        
        // Buttons
        Button.appearance().backgroundColor = darkBlue
        TagLabel.appearance().backgroundColor = darkBlue
        
        // TableView
        UITableView.appearance().backgroundColor = UIColor.white
        UITableViewCell.appearance().backgroundColor = UIColor.white
        ContextLabel.appearance().textColor = UIColor.black
        UITableViewHeaderFooterView.appearance().tintColor = UIColor.lightGray
        UITableView.appearance().sectionIndexBackgroundColor = UIColor.white
        UITableView.appearance().sectionIndexColor = UIColor.blue
        AttributeLabel.appearance().textColor = UIColor.black
        AttributeTextView.appearance().textColor = UIColor.black
        AttributeAnswerTextView.appearance().backgroundColor = UIColor.gray
        AttributeAnswerTextView.appearance().textColor = UIColor.black
        
        // Switches
        UISwitch.appearance().onTintColor = darkBlue
    }
    
    static func defaultBackground() -> UIColor {
        return UIColor.white
    }
    
    static func defaultCellOutline() -> CGColor {
        return UIColor.blue.cgColor
    }
    
    static func InvaderGreenTheme() {
        
        // Colors
        let deepInk = UIColor(red: 3.0/255.0, green: 12.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        let yourSmellIsALie = UIColor(red: 12.0/255.0, green: 36.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        let unAzul = UIColor(red: 26.0/255.0, green: 82.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        
        // Status bar
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Navigaton bar
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // Tab bar
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().tintColor = UIColor.white
        
        // Background colors
        UILabel.appearance().backgroundColor = UIColor.clear
        UITextField.appearance().backgroundColor = yourSmellIsALie
        UICollectionView.appearance().backgroundColor = yourSmellIsALie
        UITextView.appearance().backgroundColor = yourSmellIsALie
        
        // Page headers
        HeaderLabel.appearance().backgroundColor = deepInk
        
        // Text
        UITextField.appearance().textColor = UIColor.white
        UITextView.appearance().textColor = UIColor.white
        
        // Buttons
        Button.appearance().backgroundColor = unAzul
        TagLabel.appearance().backgroundColor = unAzul
        
        // TableView
        UITableView.appearance().backgroundColor = yourSmellIsALie
        UITableViewCell.appearance().backgroundColor = yourSmellIsALie
        ContextLabel.appearance().textColor = UIColor.white
        UITableViewHeaderFooterView.appearance().tintColor = unAzul
        UITableView.appearance().sectionIndexBackgroundColor = unAzul
        UITableView.appearance().sectionIndexColor = UIColor.white
        AttributeLabel.appearance().textColor = UIColor.white
        AttributeTextView.appearance().textColor = UIColor.white
        AttributeAnswerTextView.appearance().backgroundColor = unAzul
        AttributeAnswerTextView.appearance().textColor = UIColor.white

        // Switches 
        UISwitch.appearance().onTintColor = unAzul
    }
    
    static func InvaderGreenBackground() -> UIColor {
        let yourSmellIsALie = UIColor(red: 12.0/255.0, green: 36.0/255.0, blue: 48.0/255.0, alpha: 1.0)

        return yourSmellIsALie
    }
    
    static func InvaderGreenCellOutline() -> CGColor {
        return UIColor.blue.cgColor
    }

    static func EnvyTheme() {
        
        // Colors
        let darkGreen = UIColor(red: 25.0/255.0, green: 77.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        // Status bar
        UIApplication.shared.statusBarStyle = .default
        
        // Navigaton bar
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = darkGreen
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        
        // Tab bar
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = darkGreen
        
        // Background colors
        UILabel.appearance().backgroundColor = UIColor.clear
        UITextField.appearance().backgroundColor = UIColor.white
        UICollectionView.appearance().backgroundColor = UIColor.white
        UITextView.appearance().backgroundColor = UIColor.white
        
        // Page headers
        HeaderLabel.appearance().backgroundColor = darkGreen
        
        // Text
        UITextField.appearance().textColor = UIColor.black
        UITextView.appearance().textColor = UIColor.black
        
        // Buttons
        Button.appearance().backgroundColor = darkGreen
        TagLabel.appearance().backgroundColor = darkGreen
        
        // TableView
        UITableView.appearance().backgroundColor = UIColor.white
        UITableViewCell.appearance().backgroundColor = UIColor.white
        ContextLabel.appearance().textColor = UIColor.black
        UITableViewHeaderFooterView.appearance().tintColor = UIColor.lightGray
        UITableView.appearance().sectionIndexBackgroundColor = UIColor.white
        UITableView.appearance().sectionIndexColor = darkGreen
        AttributeLabel.appearance().textColor = UIColor.black
        AttributeTextView.appearance().textColor = UIColor.black
        AttributeAnswerTextView.appearance().backgroundColor = UIColor.gray
        AttributeAnswerTextView.appearance().textColor = UIColor.black
        
        // Switches
        UISwitch.appearance().onTintColor = darkGreen
    }
    
    static func EnvyBackground() -> UIColor {
        return UIColor.white
    }
    
    static func EnvyCellOutline() -> CGColor {
        return UIColor.green.cgColor
    }
}
