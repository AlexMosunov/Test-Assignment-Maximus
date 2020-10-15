//
//  CollectionViewCell.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 05.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import AppstoreTransition
import AVFoundation
import Kingfisher

protocol CollectionViewNew {
    func onClickCellButton(index: IndexPath)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var newItemLabel: UILabel!
    
    
    var collectionCellDelegate: CollectionViewNew?
    var index: IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .init(width: 0, height: 0)
        layer.shadowRadius = 8
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            UIBlurEffect.Style.light))
        blur.frame = openButton.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = blur.frame.height / 2
        blur.layer.masksToBounds = true
        openButton.insertSubview(blur, at: 0)
        
        newItemLabel.alpha = 0.0
        openButton.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.newItemLabel.alpha = 1.0
            self.openButton.alpha = 1.0
        }
        newItemLabel.alpha = 0.0
        
    }
    
  

    @IBAction func openButtonTapped(_ sender: UIButton) {

        if let index = index {
            collectionCellDelegate?.onClickCellButton(index: index)
        }
    }
    
    func updateUI(image: String?, btnLabel: String?, newItemLbl: String?, itemNumber: Int) {
        setLabelsUI()
        if itemNumber >= 5 {
            newItemLabel.alpha = 0.0
        } else {
            newItemLabel.alpha = 1.0
        }
        openButton.setTitle(btnLabel ?? "Open", for: .normal)
        newItemLabel.text = newItemLbl ?? "New"
        
        guard let imageString = image else { return }
        
        guard let imageStringURL = URL(string: imageString) else { return }
        
        imageView.kf.setImage(with: imageStringURL)
  
    }
    
    

    
    func setLabelsUI() {
        newItemLabel.layer.masksToBounds = true
        newItemLabel.layer.cornerRadius = newItemLabel.frame.height / 2
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
        openButton.layer.cornerRadius = openButton.frame.height / 2
    }
    


}


extension CollectionViewCell: CardCollectionViewCell {
    
    var cardContentView: UIView {
        get {
            return containerView
        }
    }
    
}


extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
