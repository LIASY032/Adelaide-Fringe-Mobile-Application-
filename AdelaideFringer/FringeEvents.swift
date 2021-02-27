//
//  FringeEvents.swift
//  Fringer
//
//  Created by Fan Liang on 14/10/20.
//

import Foundation
import UIKit


struct Events{
    var id: String
    var name: String
    var artist: String
    var venue: String
    var likes: String
    var dislikes: String
    var image: String
    var description: String
    
    init(_ events: [String: Any]) {
        self.id = events["id"] as? String ?? ""
        self.name = events["name"] as? String ?? ""
        self.artist = events["artist"] as? String ?? ""
        self.venue = events["venue"] as? String ?? ""
        self.likes = events["likes"] as? String ?? ""
        self.dislikes = events["dislikes"] as? String ?? ""
        self.image = events["image"] as? String ?? ""
        self.description = events["description"] as? String ?? ""
    }
}

class EventModel {
    private var model = [Events]()
    private var i = [[String: Any]]()
    private var listImage = [UIImage]()
    private var count = 0
    
    func getEventData(completion: @escaping (Result<[Events], Error>) -> Void){
        let urlString = "http://www.partiklezoo.com/fringer/"
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                
                //convert jsonResponse as an array
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                      return
                }
                
                self.i = jsonArray
                var index = 0
                for event in jsonArray{
                    
                    self.model.append(Events(event))
                    let imageString = "https://www.partiklezoo.com/fringer/images/\(self.model[index].image)"
                    guard let imageurl = URL(string: imageString) else{
                        return
                    }
                    do {
                        let imageData = try Data(contentsOf: imageurl)
                        guard let image = UIImage(data: imageData) else {
                            return
                        }
                        self.listImage.append(image)
                    } catch{
                        print("Error Image")
                    }
                    
                    index += 1

                    
                }
                
                DispatchQueue.main.async {
                    
                    completion(.success(self.model))
                    
                }
                
                
                
             } catch let error {
                completion(.failure(error))
             }
        }
        task.resume()
        
    }
    

    func getlistImage() -> [UIImage]{
        return listImage
    }
    
    func getL() -> Int{
        return listImage.count
    }
}
