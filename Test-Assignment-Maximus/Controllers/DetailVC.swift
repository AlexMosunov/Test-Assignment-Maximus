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
    var mainVC: MainViewController?
    
    var picture: UIImage?
    var detailsDelegate: Details?
    
    var wallpaperObject: DataModel?
    var copyright: String?
    
    var numberOfTaps = 0
    
    var imageOne: UIImage?
    var imageTwo: UIImage?
    
    var spinnerView: UIView?
    var statusBarManager: UIStatusBarManager?
    var openedImage = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        contentScrollView.delegate = self
        apiManager?.pairDelegate = self
        
        let scrollSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = scrollSize

        scrollView.contentInsetAdjustmentBehavior = .never

        let _ = dismissHandler

        setUI()
        
        // adding gesture recognizer to the header view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnHeaderView(sender:)))
        headerView.addGestureRecognizer(tapGesture)
        
        modalPresentationCapturesStatusBarAppearance = true
        setNeedsStatusBarAppearanceUpdate()
        
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
    
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override var prefersStatusBarHidden: Bool {
        if openedImage {
            return false
        } else {
            return true
        }
    }

    
    func setUI() {
        
        watchButton.setTitle(apiManager?.localizationObject?.input_8 ?? "Preview", for: .normal)
        downloadButton.setTitle(apiManager?.localizationObject?.input_9 ?? "Download", for: .normal)
        
        
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

            openedImage = true
            setNeedsStatusBarAppearanceUpdate()
            
            // setting first preview image with preset image
            guard let urlOne = URL(string: "https://pair.maximusapps.top/storage/\(wallpaperObject.image_1)") else {return}
            wallpaperImageOne.kf.indicatorType = .activity
            wallpaperImageOne.kf.setImage(with: urlOne, completionHandler:  { result in
//                self.wallpaperImageOne.image = self.wallpaperImageOne.image?.resizeTopAlignedToFill(newWidth: self.imageView.frame.width)
                self.presetImageOne.contentMode = .top
                self.presetImageOne.clipsToBounds = true
                let image = UIImage(named: "preset1")
                self.presetImageOne.image = image?.resizeTopAlignedToFill(newWidth: self.imageView.frame.width)
                self.wallpaperImageOne.contentMode = .top
                self.wallpaperImageOne.clipsToBounds = true
                self.wallpaperImageOne.image = self.wallpaperImageOne.image?.resizeTopAlignedToFill(newWidth: self.imageView.frame.width)
            })

            // setting second preview image with preset image
            guard let urlTwo = URL(string: "https://pair.maximusapps.top/storage/\(wallpaperObject.image_2)") else {return}
            wallpaperImageTwo.kf.setImage(with: urlTwo, completionHandler:  { result in
                self.presetImageTwo.contentMode = .top
                self.presetImageTwo.clipsToBounds = true
                let image = UIImage(named: "preset2")
                self.presetImageTwo.image = image?.resizeTopAlignedToFill(newWidth: self.imageView.frame.width)
                self.wallpaperImageTwo.contentMode = .top
                self.wallpaperImageTwo.clipsToBounds = true
                self.wallpaperImageTwo.image = self.wallpaperImageTwo.image?.resizeTopAlignedToFill(newWidth: self.imageView.frame.width)
            })
            
            // adding gesture recognizer to the gesture view
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnImage(sender:)))
            gestureView.addGestureRecognizer(tapGesture)
            
            
            gestureView.alpha = 1.0
            wallpaperImageOne.alpha = 1.0
            wallpaperImageTwo.alpha = 1.0
            presetImageOne.alpha = 1.0
            presetImageTwo.alpha = 1.0
            dismissEnabled = false
        }
    }
    
    
    func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
      guard let url = URL.init(string: urlString) else {
          return  imageCompletionHandler(nil)
      }
      let resource = ImageResource(downloadURL: url)
      
      KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
        switch result {
        case .success(let value):
            print("image downloaded")
            imageCompletionHandler(value.image)
        case .failure:
            print("image failed to download")
            imageCompletionHandler(nil)
        }
      }
    }
    
    
    @IBAction func watchButtonTapped(_ sender: UIButton) {
        setPreviewImages()
    }
    
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        if let apiManager = apiManager, let wallpaperObject = apiManager.wallpaperObject {
            
            downloadImage(with :"https://pair.maximusapps.top/storage/\(wallpaperObject.image_1)"){image in
                guard let image  = image else { return}
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                // do what you need with the returned image.
            }
            
            downloadImage(with :"https://pair.maximusapps.top/storage/\(wallpaperObject.image_2)"){image in
                guard let image  = image else { return}
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                // do what you need with the returned image.
            }
        }
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.4) {
            self.cancelButton.alpha = 0.0
        }
        self.dismiss(animated: true)
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    

    @objc func handleTapOnHeaderView(sender: UITapGestureRecognizer) {
        setPreviewImages()
    }
    
    
    @objc func handleTapOnImage(sender: UITapGestureRecognizer) {
        
        numberOfTaps += 1
        
        switch numberOfTaps {
        case 1:
            UIView.animate(withDuration: 0.2) {
                self.wallpaperImageOne.alpha = 0.0
                self.presetImageOne.alpha = 0.0
            }
        case 2:
            UIView.animate(withDuration: 0.2) {
                self.wallpaperImageTwo.alpha = 0.0
                self.presetImageTwo.alpha = 0.0
            }
            numberOfTaps = 0
            gestureView.alpha = 0.0
            dismissEnabled = true
            openedImage = false
            setNeedsStatusBarAppearanceUpdate()
        default:
            wallpaperImageOne.image = UIImage()
            wallpaperImageTwo.image = UIImage()
        }

    }
    
    
    

}


extension DetailVC: APIWallpaperDelegate {
    func didUpdatePairData(_ DataManager: APIManager, data: WallpaperData) {
        DispatchQueue.main.async {
            self.authorLabel.text = self.apiManager?.wallpaperObject?.copyright ?? ""
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
        
                
    }
    
}




extension DetailVC: CardDetailViewController {
    var scrollView: UIScrollView {
        let scrollSize = CGSize(width: view.frame.width, height: view.frame.height)
        contentScrollView.contentSize = scrollSize
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
