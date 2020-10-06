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

protocol CollectionViewNew {
    func onClickCellButton(index: IndexPath)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var newItemLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    
    var collectionCellDelegate: CollectionViewNew?
    var index: IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
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
    }
    
    
    
    @IBAction func openButtonTapped(_ sender: UIButton) {
        if let index = index {
            collectionCellDelegate?.onClickCellButton(index: index)
        }
    }
    
    func updateUI(image: String?) {
        setLabelsUI()
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        guard let imageString = image else { return }
        
        guard let imageStringURL = URL(string: imageString) else { return }
        
        getImageDataFrom(url: imageStringURL)
        
    }
    
    

    
    func setLabelsUI() {
        newItemLabel.layer.masksToBounds = true
        newItemLabel.layer.cornerRadius = newItemLabel.frame.height / 2
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        openButton.layer.cornerRadius = openButton.frame.height / 2
        

    }
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                 return
             }
             
             DispatchQueue.main.async {
                 if let image = UIImage(data: data) {
                    self.imageView.image = image.resized(withPercentage: 0.5)
                 }
             }
         }.resume()
     }
    
    
    // Make it appears very responsive to touch
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        animate(isHighlighted: true)
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        animate(isHighlighted: false)
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//        animate(isHighlighted: false)
//    }


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
