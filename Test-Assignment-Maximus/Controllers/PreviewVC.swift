//
//  PreviewVC.swift
//  Test-Assignment-Maximus
//
//  Created by iOS on 12.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import Kingfisher

class PreviewVC: UIViewController {

    @IBOutlet weak var wallpaperTwoImage: UIImageView!
    @IBOutlet weak var wallpaperOneImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    
    var wallpaperObject: WallpaperData?
    var apiManager: APIManager?
    var numberOfTaps = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let apiManager = apiManager, let wallpaperObject = apiManager.wallpaperObject {
            print("wallpaperObject.image_1 - \(wallpaperObject.image_1)")
            guard let urlOne = URL(string: "https://pair.maximusapps.top/storage/\(wallpaperObject.image_1)") else {return}
            wallpaperOneImage.kf.setImage(with: urlOne)
            guard let urlTwo = URL(string: "https://pair.maximusapps.top/storage/\(wallpaperObject.image_2)") else {return}
            wallpaperTwoImage.kf.setImage(with: urlTwo)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnImage(sender:)))
            topView.addGestureRecognizer(tapGesture)
        }
        
        
    
    }
    
    @objc func handleTapOnImage(sender: UITapGestureRecognizer) {
        
        numberOfTaps += 1
        self.dismiss(animated: true)
        
//        switch numberOfTaps {
//        case 1:
//            print(111)
//            UIView.animate(withDuration: 0.3) {
//                self.wallpaperOneImage.alpha = 0.0
//            }
//        case 2:
//            print(222)
//            self.dismiss(animated: true)
//        default:
//            print("error with preview images")
//        }
        
        
//        print("hello")

    }
    



}
