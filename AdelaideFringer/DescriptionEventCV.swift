//
//  DescriptionEventCV.swift
//  Adelaide Fringe
//
//  Created by Fan Liang on 26/10/20.
//

import UIKit

import MapKit

protocol DescriptionEventCVDelegate {
    func refreshTableView()
    func didSetEvents(_ newEvents: [Events])
}


class DescriptionEventCV: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var likes: UILabel!
    
    @IBOutlet weak var dislikes: UILabel!
    
    
    @IBOutlet weak var artist: UILabel!
    
    
    @IBOutlet weak var venue: UILabel!
    
    
    @IBOutlet weak var descriptionView: UITextView!
    
    
    @IBOutlet weak var eventImage: UIImageView!
    
    let regionInMeters: Double = 100000
    
    var event:Events!
    
    var desriptionVenue: Venues!
    
    var locationManager = CLLocationManager()
    
//    var venueModel: FringeVenues!
    
    var displayIndex = 0;
    
    var delegate: DescriptionEventCVDelegate!
    
    var listEvent:[Events]!
    
    @IBOutlet weak var flag: UIImageView!
    
    
    //point out the interesting event
    let flagImage:UIImage = #imageLiteral(resourceName: "images")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(upSwipe)

        if (eventListinterested[displayIndex] == 1){
            flag.image = flagImage
        }
        descriptionView?.text = event.description
        name?.text = event.name
        venue?.text = event.venue
        artist?.text = event.artist
        likes?.text = event.likes
        dislikes?.text = event.dislikes
        let imageString = "https://www.partiklezoo.com/fringer/images/\(event.image)"
        let imageurl = URL(string: imageString)
        var image:UIImage!
        do {
            let imageData = try Data(contentsOf: imageurl!)
            image = UIImage(data: imageData)
        } catch{
            print("Error Image")
        }
        eventImage?.image = image
        
        
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
        
        //points out the event location
        if (venuemodel.hasVenue(event.id)){
            let latitude1: Double = Double(venuemodel.findVenues(event.id).latitude)!
            let longtitude1: Double = Double(venuemodel.findVenues(event.id).longitude)!
            let location = CLLocationCoordinate2D.init(latitude: latitude1, longitude: longtitude1)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            annotation.title = event.name
            
            annotation.subtitle = event.venue
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    
    //swipe up for the interesting
    @objc func swipeAction(swipe:UISwipeGestureRecognizer)
    {
        
        if (indexList[displayIndex] == 0){
            indexList[displayIndex] = 1
            eventListinterested[displayIndex] = 1
            print("interested")
            flag.image = flagImage
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Success", message: "Your request was already sent", preferredStyle: .alert)
            
            
            let ok = UIAlertAction(title: "OK", style: .default)
            postinterested(postID: event.id)
           
            
            dialogMessage.addAction(ok)
            
                    
            
            self.present(dialogMessage, animated: true, completion: nil)
            
                    
            
          
            
        }else{
            indexList[displayIndex] = 0
            eventListinterested[displayIndex] = 0
            print("uninterested")
            flag.image = nil
        }
        
        record.changeIndexList(changeIndex: displayIndex, newinterestedEvent: indexList[displayIndex])
       
        
    }

    
    //when press the back button, it implement these functions
    @IBAction func back(_ sender: Any) {
        delegate.didSetEvents(listEvent)
        allimages = eventlistimages
        delegate.refreshTableView()
        eventListlikes = indexlikes
        eventListinterested = indexList
    }
    

    
    
    
    //this delegate function is for displaying the route overlay and styling it
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor.red
         renderer.lineWidth = 5.0
         return renderer
    }
    
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    

    //post the interested event to the server
    func postinterested(postID: String){
//        let parameters = ["result": "success", "id": postID, "email": useremail] as [String : Any]
        let parameters = ["result": "success", "id": postID]
        print("post")
        guard  let url = URL(string: "http://partiklezoo.com/fringer/?action=register&id=\(postID)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
        
    }
    
}

extension DescriptionEventCV {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }

}
