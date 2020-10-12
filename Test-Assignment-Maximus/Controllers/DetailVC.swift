//
//  DetailVC.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 05.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import AppstoreTransition
import Kingfisher


protocol Details {
    func passCellIndex(index: IndexPath)
}

class DetailVC: UIViewController {


    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var wallpaperImageTwo: UIImageView!
    @IBOutlet weak var wallpaperImageOne: UIImageView!
    @IBOutlet weak var presetImageTwo: UIImageView!
    @IBOutlet weak var presetImageOne: UIImageView!
    
    
    
    var apiManager: APIManager?
    var index: IndexPath?
    
    var picture: UIImage?
    var detailsDelegate: Details?
    
    var wallpaperObject: DataModel?
    
    var numberOfTaps = 0
    var previewImageIsBeingShown = false
    
    var spinnerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        contentScrollView.delegate = self
        
        let scrollSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = scrollSize

        scrollView.contentInsetAdjustmentBehavior = .never

        let _ = dismissHandler

        setUI()
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gestureView.alpha = 0
        wallpaperImageOne.alpha = 0
        wallpaperImageTwo.alpha = 0
        presetImageOne.alpha = 0
        presetImageTwo.alpha = 0

        authorLabel.alpha = 0.0
        UIView.animate(withDuration: 0.7) {
            self.authorLabel.alpha = 1.0
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelButton.alpha = 0.0
        authorLabel.alpha = 0.0
        
        if let index = index {
            detailsDelegate?.passCellIndex(index: index)
        }
    }
    
    
    func setUI() {
        watchButton.layer.cornerRadius = watchButton.frame.height / 2
        downloadButton.layer.cornerRadius = downloadButton.frame.height / 2
        cancelButton.layer.cornerRadius = 50
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            UIBlurEffect.Style.regular))
        blur.frame = cancelButton.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = blur.frame.height / 2
        blur.layer.masksToBounds = true
        cancelButton.insertSubview(blur, at: 0)
        cancelButton.bringSubviewToFront(cancelButton.imageView!)
        cancelButton.alpha = 1.0
        imageView.layer.cornerRadius = 10
        
    }
    
    
    func setPreviewImages() {
        if let apiManager = apiManager, let wallpaperObject = apiManager.wallpaperObject {
            print("wallpaperObject.image_1 - \(wallpaperObject.image_1)")
            guard let urlOne = URL(string: "https://pair.maximusapps.top/storage/\(wallpaperObject.image_1)") else {return}

            wallpaperImageOne.kf.indicatorType = .activity
            wallpaperImageOne.kf.setImage(with: urlOne, completionHandler:  { result in
                print(result)
                self.presetImageOne.image = UIImage(named: "preset1")
            })
            
            
            guard let urlTwo = URL(string: "https://pair.maximusapps.top/storage/\(wallpaperObject.image_2)") else {return}
            
            wallpaperImageTwo.kf.setImage(with: urlTwo, completionHandler:  { result in
                
                self.presetImageTwo.contentMode = .top
                self.presetImageTwo.clipsToBounds = true
                let image = UIImage(named: "preset2")
                
                self.presetImageTwo.image = image?.resizeTopAlignedToFill(newWidth: self.imageView.frame.width)

            })

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnImage(sender:)))
            gestureView.addGestureRecognizer(tapGesture)
        }
    }
    
    
    @IBAction func watchButtonTapped(_ sender: UIButton) {
        previewImageIsBeingShown = true
        setPreviewImages()
        gestureView.alpha = 1.0
        wallpaperImageOne.alpha = 1.0
        wallpaperImageTwo.alpha = 1.0
        presetImageOne.alpha = 1.0
        presetImageTwo.alpha = 1.0
        

    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.4) {
            self.cancelButton.alpha = 0.0
        }
        self.dismiss(animated: true)
    }
    

    
    
    @objc func handleTapOnImage(sender: UITapGestureRecognizer) {
        
        numberOfTaps += 1
        
        switch numberOfTaps {
        case 1:
            print(111)
            UIView.animate(withDuration: 0.2) {
                self.wallpaperImageOne.alpha = 0.0
                self.presetImageOne.alpha = 0.0
            }
        case 2:
            print(222)
            UIView.animate(withDuration: 0.2) {
                self.wallpaperImageTwo.alpha = 0.0
                self.presetImageTwo.alpha = 0.0
            }
            numberOfTaps = 0
            gestureView.alpha = 0.0
        default:
            previewImageIsBeingShown = false
            wallpaperImageOne.image = UIImage()
            wallpaperImageTwo.image = UIImage()
            print("error with preview images")
        }

    }
    

}


extension DetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // prevent bouncing when swiping down to close
        scrollView.bounces = scrollView.contentOffset.y > 100
        dismissHandler.scrollViewDidScroll(scrollView)
        
        // hide cancel button onscroll
        if scrollView.contentOffset.y > 5 {
            let percent = scrollView.contentOffset.y / 100
            cancelButton.alpha = 1.0 - percent
        }
        
        print(previewImageIsBeingShown)
        if previewImageIsBeingShown {
            contentScrollView.isScrollEnabled = false
        }
                
    }
    

    
}


extension DetailVC: CardDetailViewController {
    var scrollView: UIScrollView {
        let scrollSize = CGSize(width: view.frame.width, height: view.frame.height)
        contentScrollView.contentSize = scrollSize
//        contentScrollView.isScrollEnabled = false
        return contentScrollView
    }
    
    
    
    var cardContentView: UIView {
        return headerView
    }

}




extension UIImage {
    func resizeTopAlignedToFill(newWidth: CGFloat) -> UIImage? {
        let newHeight = size.height * newWidth / size.width

        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
