//
//  APIManager.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 04.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import Foundation

protocol APIManangerDelegate {
    func didUpdateData(_ DataManager: APIManager, data: [String])
}

class APIManager {
    
    let APIurl = "https://pair.maximusapps.top/api/get-all-pairs"
    var imageURLsArray: [String] = []
    
    var delegate: APIManangerDelegate?
    
    func postRequest() {
        guard let url = URL(string: APIurl) else { return }
        let parameters = ["":""]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
    
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed) else { return }
        request.httpBody = httpBody
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
////                print(response)
//            }
            
            if let data = data, let _ = String(data: data, encoding: .utf8) {
                if let safeData = self.parseJSON(data: data) {
                    //call delegate
                    self.delegate?.didUpdateData(self, data: safeData)
//                    for imageURLString in safeData {
//                        if imageURLString != "" {
//                            self.delegate?.didUpdateData(self, data: imageURLString)
//                        }
//
//                    }
                    
//                    self.imageURLsArray = safeData
//                    print("safeData = \(safeData)")
                }
            }
            
        }.resume()
        
    }

    
    
        func parseJSON(data: Data) -> [String]? {
            
            let prefixURL = "https://pair.maximusapps.top/storage/"
            var imageURLs: [String] = []
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(APIData.self, from: data)
                
                for object in decodedData.data {
                    
                    imageURLs.append("\(prefixURL)\(object.image_1)")
//                    print("image - \(prefixURL)\(object.image_1)")
                }

            return imageURLs
                
//                let imagestr = "https://pair.maximusapps.top/storage/\(decodedData.data[0].image_1)"
//                print("imagestr - \(imagestr)")
//                guard let url = URL(string: imagestr) else { return }
//
//                let data = try Data(contentsOf: url)
//                DispatchQueue.main.async {
//                    self.image.image = UIImage(data: data)
//                }

                
            } catch {
                print(error)
                return nil
            }
            
            
            
        }
    
    
//    func fetchImage(urlString : String) -> Data {
//        // Create Data Task
//        var request: URLRequest? = nil
//        let task = URLSession.shared.dataTask(with: request!, completionHandler: { [weak self] (data, _, _) in
//            if let data = data {
//
//                DispatchQueue.main.async {
//                    // Create Image and Update Image View
//                    return UIImage(data: data)
//                }
//            }
//        })
//
//        // Start Data Task
//        task.resume()
//
//    }
    
}
