//
//  NetworkManager.swift
//  discoverdevice
//
//  Created by Anujith on 21/06/22.
//

import Foundation

class NetworkManager {
    
    func fetchPublicIP(completionHandler: @escaping (PublicIPModel) -> Void) {
        
        let url = URL(string: "https://api.ipify.org?format=json")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

          if let data = data,
            let publicIPModel = try? JSONDecoder().decode(PublicIPModel.self, from: data) {
            completionHandler(publicIPModel)
          }
        })
        task.resume()
        
    }
    
    func fetchPublicIPDetails(ipAddress:String, completionHandler: @escaping (IPDetailsModel) -> Void) {
        
        let url = URL(string: "https://ipinfo.io/\(ipAddress)/geo")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

          if let data = data,
            let ipDetailsModel = try? JSONDecoder().decode(IPDetailsModel.self, from: data) {
            completionHandler(ipDetailsModel)
          }
        })
        task.resume()
        
    }
}

