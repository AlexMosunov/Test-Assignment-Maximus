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
    
    
    var apiManager: APIManager?
    var index: IndexPath?
    
    var picture: UIImage?
    var detailsDelegate: Details?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        contentScrollView.delegate = self
//        scrollViewNew.isScrollEnabled = false
        
        let scrollSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = scrollSize
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let _ = dismissHandler

        setUI()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    
    
    @IBAction func watchButtonTapped(_ sender: UIButton) {
        print("")
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.4) {
            self.cancelButton.alpha = 0.0
        }
        self.dismiss(animated: true)
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
