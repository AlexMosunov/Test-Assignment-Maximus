//
//  APIManager.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 04.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import Foundation
import UIKit

protocol APIManangerDelegate {
    func didUpdateData(_ DataManager: APIManager, data: [DataModel])
}

class APIManager {
    
    let pairAPIurl = "https://pair.maximusapps.top/api/get-pair"
    
    var APIurl = "https://pair.maximusapps.top/api/get-all-pairs"
    var imageObjectsArray: [DataModel] = []
    var imagesArray: [UIImage] = []
    var nextPage: String?
    var wallpaperObject: WallpaperData?
    
    var delegate: APIManangerDelegate?
    
    func postRequest() {
        if let nextPage = nextPage {
            APIurl = nextPage
        }
        guard let url = URL(string: APIurl) else { return }
        let parameters = ["":""]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed) else { return }
        request.httpBody = httpBody
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data, let _ = String(data: data, encoding: .utf8) {
                if let safeData = self.parseJSON(data: data) {
                    print("data = \(safeData)")
                    
                    self.delegate?.didUpdateData(self, data: safeData)
                }
            }
            
        }.resume()
        
    }
    
    
    func postRequest(id: Int) {
        guard let url = URL(string: pairAPIurl) else { return }
        let parameters = ["id":id]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed) else { return }
        request.httpBody = httpBody
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data, let _ = String(data: data, encoding: .utf8) {
                print("PAIRdata = \(data)")
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(PairAPIData.self, from: data)
                    
                    let id = decodedData.id
                    let image1 = decodedData.image_1
                    let image2 = decodedData.image_2
                    let image3 = decodedData.image_3
                    let closed = decodedData.closed
                    let copyright = decodedData.copyright
                    
                    self.wallpaperObject = WallpaperData(id: id, image_1: image1, image_2: image2, image_3: image3, closed: closed, copyright: copyright)
                    
                    
                    print(decodedData.id)
                } catch {
                    
                    
                }
//                if let safeData = self.parseJSON(data: data) {
//                    print("PAIRdata = \(safeData)")
//
//                }
            }
            
        }.resume()
    }
    
    
    
    func parseJSON(data: Data) -> [DataModel]? {
        
        let prefixURL = "https://pair.maximusapps.top/storage/"
        var imageURLs: [DataModel] = []
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(APIData.self, from: data)
            
            nextPage = decodedData.next_page_url
            guard let data = decodedData.data else { return nil}
            
            for object in data {
                let id = object.id
                let imageUrl = object.image_3
                
                let object = DataModel(id: id, url: "\(prefixURL)\(imageUrl)")
                
                imageURLs.append(object)
            }
            
            return imageURLs
            
            
        } catch {
            print(error)
            return nil
        }
    }
    

}
