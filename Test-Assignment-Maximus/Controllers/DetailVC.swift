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

class DetailVC: UIViewController {


    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var watchButton: UIButton!
    
    var apiManager: APIManager?
    var index: IndexPath?
    
    var picture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        contentScrollView.delegate = self
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let _ = dismissHandler

        setUI()
   
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
        imageView.layer.cornerRadius = 10
        
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
