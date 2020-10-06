//
//  DetailVC.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 05.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import AppstoreTransition

class DetailVC: UIViewController {


    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var apiManager: APIManager?
    var index: IndexPath?
    
    var picture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        contentScrollView.delegate = self
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let _ = dismissHandler

        loadImage()
        setUI()
   
    }
    
    
    func setUI() {
        
        cancelButton.layer.cornerRadius = 50
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            UIBlurEffect.Style.regular))
        blur.frame = cancelButton.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = blur.frame.height / 2
        blur.layer.masksToBounds = true
        cancelButton.insertSubview(blur, at: 0)
        cancelButton.bringSubviewToFront(cancelButton.imageView!)
        
    }
    
    
    func loadImage() {
        if let picture = picture {
            self.imageView.image = picture.resized(withPercentage: 0.5)
        }
        
        
//        if let index = index {
//            guard let imageURLString = apiManager?.imageURLsArray[index.row] else {return }
//            guard let url = URL(string: imageURLString) else {return}
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        self.imageView.image = UIImage(data: data)
//                    }
//                }
//            }
//        }
    }
    
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    


}


extension DetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // prevent bouncing when swiping down to close
        scrollView.bounces = scrollView.contentOffset.y > 100
        
        dismissHandler.scrollViewDidScroll(scrollView)
    }
    
}


extension DetailVC: CardDetailViewController {
    var scrollView: UIScrollView {
        return contentScrollView
    }
    
    
    
    var cardContentView: UIView {
        return headerView
    }

}
