//
//  ViewController.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 04.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    
    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var objectTableView: UITableView!
    var apiManager = APIManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        apiManager.delegate = self
        apiManager.postRequest()
        
        // Do any additional setup after loading the view.
    }


    func playVideo() {
        guard let path = Bundle.main.path(forResource: "gradient_60", ofType: "mp4") else {
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        
        player.play()
        
//        videoLayer.bringSubviewToFront(img)
//        videoLayer.bringSubviewToFront(lbl)
//        videoLayer.bringSubviewToFront(signIn)
//        videoLayer.bringSubviewToFront(signUp)
//        videoLayer.bringSubviewToFront(stack)
    }
    
}


extension ViewController: UITableViewDelegate {
    
    
    
}





extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiManager.imageURLsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = objectTableView.dequeueReusableCell(withIdentifier: "ObjectCell", for: indexPath) as! TableViewCell

        
        let imageURLString = apiManager.imageURLsArray[indexPath.row]
        print("imageURLString !!! - \(imageURLString)")
        cell.updateUI(image: imageURLString)

        
//        if let imageURL = URL(string: imageURLString) {
//            // Create Data Task
//            let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, _) in
//                if let data = data {
//
//                    DispatchQueue.main.async {
//                        // Create Image and Update Image View
//                        cell.myImageView.image = UIImage(data: data)
//                    }
//                }
//            })
//            task.resume()
//        }
        

         // Start Data Task
         
         
        
//

//        DispatchQueue.global().async {
//            do {
//                if let url = URL(string: imageURLString) {
//                    let data = try Data(contentsOf: url)
//                    DispatchQueue.main.async {
//                        cell.myImageView.image = UIImage(data: data)
//                    }
//                }
//            } catch {
//                print("error with image url- \(error)")
//            }
//        }
//        cell.myImageView.image = nil
//
//
        
//        if let url = URL(string: imageURLString) {
//             let data = try Data(contentsOf: url)
//            DispatchQueue.main.async {
////                self.cell. = UIImage(data: data)
//            }
//        }
        
//  let data = try Data(contentsOf: url) {
//            DispatchQueue.main.async {
//                self. = UIImage(data: data)
//            }
//        }
                        
            
        return cell
        
    }
    
    
    
    
}





extension ViewController: APIManangerDelegate {
    func didUpdateData(_ DataManager: APIManager, data: [String]) {
//        apiManager.imageURLsArray = data
        print(data)
  
        apiManager.imageURLsArray = data
        print(apiManager.imageURLsArray)
        print(apiManager.imageURLsArray.count)
//        let indexPath = IndexPath(row: apiManager.imageURLsArray.count - 1, section: 0)
//
        DispatchQueue.main.async {
            self.objectTableView.reloadData()
        }
        
//        DispatchQueue.main.async {
//            self.objectTableView.beginUpdates()
//            self.objectTableView.insertRows(at: [indexPath], with: .automatic)
//            self.objectTableView.endUpdates()
//        }
    }
    
    
}
