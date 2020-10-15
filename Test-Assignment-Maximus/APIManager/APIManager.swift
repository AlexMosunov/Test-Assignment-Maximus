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

protocol APILocalizationDelegate {
    func didUpdateLocalizationData(_ DataManager: APIManager, data: LocalizationData)
}

protocol APIWallpaperDelegate {
    func didUpdatePairData(_ DataManager: APIManager, data: WallpaperData)
}

class APIManager {
    
    let pairAPIurl = "https://pair.maximusapps.top/api/get-pair"
    let languageAPIurl = "https://pair.maximusapps.top/api/options"
    var APIurl = "https://pair.maximusapps.top/api/get-all-pairs"
    var imageObjectsArray: [DataModel] = []
    var imagesArray: [UIImage] = []
    var nextPage: String?
    var wallpaperObject: WallpaperData?
    var localizationObject: LocalizationData?
    
    var delegate: APIManangerDelegate?
    var localizationDelegate: APILocalizationDelegate?
    var pairDelegate: APIWallpaperDelegate?
    
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
//                print(response)
            }
            
            if let data = data, let _ = String(data: data, encoding: .utf8) {
                if let safeData = self.parseJSON(data: data) {

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
//                print(response)
            }
            
            if let data = data, let _ = String(data: data, encoding: .utf8) {
                
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
                    
                    if let wallpaper = self.wallpaperObject {
                        print("wallpaper")
                        self.pairDelegate?.didUpdatePairData(self, data: wallpaper)
                    }
                    
                    
                } catch {
                    print("error with getting pairs: \(error.localizedDescription)")
                    
                }
            }
            
        }.resume()
    }
    
    
    func postRequest(language: String) {
        guard let url = URL(string: languageAPIurl) else { return }
        let parameters = ["language":language]
        
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
                if let safeData = self.parseLocalizationJSON(data: data) {
                    self.localizationDelegate?.didUpdateLocalizationData(self, data: safeData)
                }

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
    
    
    
    func parseLocalizationJSON(data: Data) -> LocalizationData? {
        var localizationObj: LocalizationData?
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([LanguageAPIData].self, from: data)
            let input1 = decodedData[0].input_1
            let input2 = decodedData[0].input_2
            let input3 = decodedData[0].input_3
            let input4 = decodedData[0].input_4
            let input5 = decodedData[0].input_5
            let input6 = decodedData[0].input_6
            let input7 = decodedData[0].input_7
            let input8 = decodedData[0].input_8
            let input9 = decodedData[0].input_9
            let input10 = decodedData[0].input_10
            let input11 = decodedData[0].input_11
            let input12 = decodedData[0].input_12
            let input13 = decodedData[0].input_13
            let input14 = decodedData[0].input_14
            
            localizationObj = LocalizationData(input_1: input1,
                                                       input_2: input2,
                                                       input_3: input3,
                                                       input_4: input4,
                                                       input_5: input5,
                                                       input_6: input6,
                                                       input_7: input7,
                                                       input_8: input8,
                                                       input_9: input9,
                                                       input_10: input10,
                                                       input_11: input11,
                                                       input_12: input12,
                                                       input_13: input13,
                                                       input_14: input14)
            
            self.localizationObject = LocalizationData(input_1: input1,
                                                       input_2: input2,
                                                       input_3: input3,
                                                       input_4: input4,
                                                       input_5: input5,
                                                       input_6: input6,
                                                       input_7: input7,
                                                       input_8: input8,
                                                       input_9: input9,
                                                       input_10: input10,
                                                       input_11: input11,
                                                       input_12: input12,
                                                       input_13: input13,
                                                       input_14: input14)
         
            return localizationObj

            
        } catch {
          
            print("error with getting localization data: \(error.localizedDescription)")
            return nil
        }
    }
    

}
