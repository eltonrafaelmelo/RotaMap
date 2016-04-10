//
//  Util.swift
//  RotaMap
//
//  Created by Elton Melo on 4/9/16.
//  Copyright © 2016 Elton Melo. All rights reserved.
//

import UIKit
import SwiftLoader

class Util: NSObject {

    static let sharedInstance = Util()

    func showActivityIndicator(){
        showActivityIndicator("Carregando...")
    }
    
    func showActivityIndicator(title: String, color: UIColor = UIColor.whiteColor()){
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 120
        config.backgroundColor = UIColor.whiteColor()
        config.spinnerColor = UIColor.grayColor()
        config.titleTextColor = UIColor.grayColor()
        config.spinnerLineWidth = 2.0
        config.cornerRadius =  30
        config.foregroundColor = UIColor.blackColor()
        config.foregroundAlpha = 0.6
        SwiftLoader.setConfig(config)
        SwiftLoader.show(title: title, animated: true)
    }
    
    func hideActivityIndicator(){
        SwiftLoader.hide()
    }
    
    func showMessage(viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Rotas", message: "\(message)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        viewController.presentViewController(alert, animated: true){}
    }
    
    func showMessage(viewController: UIViewController, message: String, actionList :[UIAlertAction]) {
        let alert = UIAlertController(title: "Rotas", message: "\(message)", preferredStyle: .Alert)
        for action in actionList {
            alert.addAction(action)
        }
        viewController.presentViewController(alert, animated: true){}
    }
}
