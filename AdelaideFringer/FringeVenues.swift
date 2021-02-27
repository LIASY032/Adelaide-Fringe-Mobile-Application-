//
//  FringeVenues.swift
//  Adelaide Fringe
//
//  Created by Fan Liang on 20/10/20.
//

import UIKit


struct Venues{
    var id: String
    var name: String
    var latitude: String
    var longitude: String
    init(_ venues:[String: Any]){
        self.id = venues["id"] as? String ?? ""
        self.name = venues["name"] as? String ?? ""
        self.latitude = venues["latitude"] as? String ?? ""
        self.longitude = venues["longitude"] as? String ?? ""
    }
}


class FringeVenues{
    
    private var venues = [Venues]()
    
    func getFringeVenues(){
        guard let url = URL(string: "http://partiklezoo.com/fringer/?action=venues") else{
            return
        }


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
                
                
                DispatchQueue.main.async {
                    for venue in jsonArray{
                        self.venues.append(Venues(venue))

                    }
                }
                
                
             } catch{
                print("Error")
             }
        }
        task.resume()
        
                            
    }
    
    func getVenues() -> [Venues]{
        return venues
    }
    
    func findVenues(_ findid:String) -> Venues{
        var output:Venues!
        let findnumber = Int(findid) ?? -1
        
        for venue in venues{
            if (findnumber != -1){
                let venueid = Int(venue.id) ?? -2
                if (findnumber == venueid){
                    output = venue
                }
            }
        }
        return output
    }
    
    
    func hasVenue(_ number: String) -> Bool{
        let findnumber = Int(number) ?? -1
        for venue in venues{
            if (findnumber != -1){
                let venueid = Int(venue.id) ?? -2
                if (findnumber == venueid){
                    return true
                }
            }
        }
        return false
    }


}
