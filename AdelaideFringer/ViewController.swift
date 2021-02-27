//
//  ViewController.swift
//  AdelaideFringer
//
//  Created by Fan Liang on 29/10/20.
//

import UIKit





var indexList = [Int]()
var indexlikes = [Int]()
var changed = false
var venuemodel = FringeVenues()
var eventmodel = EventModel()
var record1 = RecordEvent()

/**
 this view controller will load the data from the core data and the internet
 pass the data to EventListViewController
 */
class ViewController: UIViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    
    var venue = FringeVenues()
    var tabBarCnt: UITabBarController!
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        venue.getFringeVenues()
        
        //load the data from the core data
        eventmodel.getEventData{
            [weak self] (result) in
            switch result{
            case .success(let event):
                self!.loading.stopAnimating()
                for _ in event{
                    indexlikes.append(0)
                    indexList.append(0)
                }
                self?.createTabBarController(event)
                
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func createTabBarController(_ events:[Events]){
        record1.fetchEvents()

        venuemodel = venue
        let eventList = storyboard?.instantiateViewController(identifier: "eventList") as! EventListViewController
        eventList.setEvents(updateEvents(eventChange: events), record1)
        eventList.setImages(eventmodel.getlistImage())
        eventList.modalPresentationStyle = .fullScreen
        self.present(eventList, animated: true, completion: nil)
        

        
    }
    
    
    //update the likes and dislikes
    func updateEvents(eventChange: [Events]) -> [Events]{
        var eventUpdate = eventChange
        for i in 0...10 {
            print(eventUpdate.count)
            if (indexlikes[i] == 1){
                
                let number = Int(eventUpdate[i].likes)! + 1
                eventUpdate[i].likes = String(number)
            }
            
            if (indexlikes[i] == -1){
                let number = Int(eventUpdate[i].dislikes)! + 1
                eventUpdate[i].dislikes = String(number)
            }
        }
        return eventUpdate
    }


}
