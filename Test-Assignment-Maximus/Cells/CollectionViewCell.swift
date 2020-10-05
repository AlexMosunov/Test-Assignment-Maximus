//
//  CollectionViewCell.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 05.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import AppstoreTransition

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
    
    
    @IBAction func openButtonTapped(_ sender: UIButton) {
        if let index = index {
            collectionCellDelegate?.onClickCellButton(index: index)
        }
    }
    
    func updateUI(image: String?) {
        newItemLabel.layer.masksToBounds = true
        newItemLabel.layer.cornerRadius = newItemLabel.frame.height / 2
        imageView.layer.cornerRadius = 15
        openButton.layer.cornerRadius = openButton.frame.height / 2
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            UIBlurEffect.Style.regular))
        blur.frame = openButton.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = blur.frame.height / 2
        blur.layer.masksToBounds = true
        openButton.insertSubview(blur, at: 0)
        
        guard let imageString = image else { return }
        
        guard let imageStringURL = URL(string: imageString) else { return }
        
        self.imageView.image = nil
        getImageDataFrom(url: imageStringURL)
        
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
                     self.imageView.image = image
                 }
             }
         }.resume()
     }
    

}

