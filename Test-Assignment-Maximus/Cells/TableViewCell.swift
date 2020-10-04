//
//  TableViewCell.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 04.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var openButton: UIButton!
    
//    private var urlString: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
    func updateUI(image: String?) {
        myImageView.layer.cornerRadius = 15
        openButton.layer.cornerRadius = openButton.frame.height / 2
        
        guard let imageString = image else { return }
        
        guard let imageStringURL = URL(string: imageString) else { return }
        
        self.myImageView.image = nil
        getImageDataFrom(url: imageStringURL)
        
        
    }
    
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.myImageView.image = image
                }
            }
        }.resume()
    }
    
    

}
