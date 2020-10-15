//
//  PhotosSavedView.swift
//  Test-Assignment-Maximus
//
//  Created by iOS on 15.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit

class PhotosSavedView: UIView {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    var openSettingsScreen = false
    
    
    public func setUI(imageName: String, mainLabelText: String, secondLabelText: String, buttonText: String, openSettings: Bool?) {
        imageView.image = UIImage(named: imageName)
        mainLabel.text = mainLabelText
        secondLabel.text = secondLabelText
        
        okayButton.layer.masksToBounds = true
        okayButton.layer.cornerRadius = 8
        okayButton.backgroundColor = .clearBlue
        okayButton.setTitle(buttonText, for: .normal)
        
        openSettingsScreen = openSettings ?? false
        
    }
    
    
    
    @IBAction func oakyButtonTapped(_ sender: UIButton) {
        
        if openSettingsScreen,
           let settingsUrl = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsUrl) {
            
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
            
        }
        
        
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.alpha = 0
                        self.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
                       }) { _ in
            self.removeFromSuperview()
        }
    }
    
    
}
