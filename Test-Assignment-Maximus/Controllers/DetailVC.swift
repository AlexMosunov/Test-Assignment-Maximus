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
    @IBOutlet weak var scrollViewNew: UIScrollView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var wallpaperImageTwo: UIImageView!
    @IBOutlet weak var wallpaperImageOne: UIImageView!
    
    
    var apiManager: APIManager?
    var index: IndexPath?
    
    var picture: UIImage?
    var detailsDelegate: Details?
    
    var wallpaperObject: DataModel?
    
    var numberOfTaps = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        view.clipsToBounds = true
        contentScrollView.delegate = self
        
        let scrollSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = scrollSize

        scrollView.contentInsetAdjustmentBehavior = .never

        let _ = dismissHandler

        setUI()
        
        
//        setPreviewImages()
//        if let id = wallpaperObject?.id {
//            apiManager?.postRequest(id: id)
//        }
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gestureView.alpha = 0
        wallpaperImageOne.alpha = 0
        wallpaperImageTwo.alpha = 0

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
            wallpaperImageOne.kf.setImage(with: urlOne)
            guard let urlTwo = URL(string: "https://pair.maximusapps.top/storage/\(wallpaperObject.image_2)") else {return}
            wallpaperImageTwo.kf.setImage(with: urlTwo)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnImage(sender:)))
            gestureView.addGestureRecognizer(tapGesture)
        }
    }
    
    
    @IBAction func watchButtonTapped(_ sender: UIButton) {
        print("BUTTON TAPPED")
        setPreviewImages()
        gestureView.alpha = 1.0
        wallpaperImageOne.alpha = 1.0
        wallpaperImageTwo.alpha = 1.0
        

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
            }
        case 2:
            print(222)
            UIView.animate(withDuration: 0.2) {
                self.wallpaperImageTwo.alpha = 0.0
            }
            numberOfTaps = 0
            gestureView.alpha = 0.0
        default:
            print("error with preview images")
        }
        
        
//        print("hello")

    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "FromDetailsToPreview" {
//            let destVC = segue.destination as! PreviewVC
//            destVC.apiManager = apiManager
//
//        }
//    }
    

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
