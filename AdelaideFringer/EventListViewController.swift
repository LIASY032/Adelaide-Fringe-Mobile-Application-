//
//  EventListViewController.swift
//  Adelaide Fringe
//
//  Created by Fan Liang on 17/10/20.
//

import UIKit
import Foundation



var allevents:[Events]!
var allimages:[UIImage]!
var record = RecordEvent()
var events: [Events]!
var eventlistimages:[UIImage]!
var eventListlikes:[Int]!
var eventListinterested:[Int]!
class EventListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    private var index = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        record.fetchEvents()
        
        for i in 0...indexList.count - 1{
            record.save(indexlikes[i], indexList[i])
        }
        eventListinterested = indexList
        eventListlikes = indexlikes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        

    }
    
    
    // for searching the events
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        events = [Events]()
        eventListlikes.removeAll()
        allimages = [UIImage]()
        eventListinterested.removeAll()
        if searchText == ""{
            events = allevents
            allimages = eventlistimages
            eventListlikes = indexlikes
            eventListinterested = indexList
        }else{
            var count = 0;
            for event in allevents{
                if event.artist.lowercased().contains(searchText.lowercased()) || event.venue.lowercased().contains(searchText.lowercased()) ||
                    event.name.lowercased().contains(searchText.lowercased()){
                    events.append(event)
                    allimages.append(eventlistimages[count])
                    eventListlikes.append(indexlikes[count])
                    eventListinterested.append(indexList[count])
                    
                }
                count += 1
            }
        }
        self.tableView.reloadData()
    }
    
    // set the Events of the EventListViewController
    func setEvents(_ newEvents:[Events], _ newRecord: RecordEvent){
        
        events = newEvents
        allevents = newEvents
        record = newRecord
        
    }
    
    func setImages(_ newImages:[UIImage]){
        allimages = newImages
        eventlistimages = newImages
    }
    
    // help the swipe left
    func dislikeAction(at indexPath:IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "dislike"){
            (action, view, completion) in
            if (eventListlikes[indexPath.row] != -1){
                var postBool = false
                
                // if the indexlikes[indexPath.row] = 0, it indicate that this is unused for likes or dislikes
                if (eventListlikes[indexPath.row] == 0){
                    postBool = true
                }
                let number = 1
                
                // if the indexlikes[indexPath.row] = 1, the dislikes should be subtract 1
                if (eventListlikes[indexPath.row] == 1){
                    let evenlikes = Int(events[indexPath.row].likes)! - number
                    events[indexPath.row].likes = String(evenlikes)
                    allevents[indexPath.row].likes = String(evenlikes)
                    
                }
                indexlikes[indexPath.row] = -1
                eventListlikes[indexPath.row] = -1
                let eventdislikes = Int(events[indexPath.row].dislikes)! + number
                events[indexPath.row].dislikes = String(eventdislikes)
                allevents[indexPath.row].dislikes = String(eventdislikes)
                
                record.change(indexPath.row, indexlikes[indexPath.row], indexList[indexPath.row] )
                

                if (postBool){
                    self.postLikes(rating: "dislike", postID: Int(events[indexPath.row].id)!, postLikes: Int(events[indexPath.row].likes)!, postDislikes: Int(events[indexPath.row].dislikes)!)
                   
                }
                self.tableView.reloadData()
                
            }
            
        }
        action.backgroundColor = .gray
        return action
    }
    
    
    // help the swipe right
    func likeAction(at indexPath:IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "like"){
            (action, view, completion) in
            if (eventListlikes[indexPath.row] != 1){
                var postBool = false
                
                // if the indexlikes[indexPath.row] = 0, it indicate that this is unused for likes or dislikes
                if (eventListlikes[indexPath.row] == 0){
                    postBool = true
                }
                let number = 1
                
                // if the indexlikes[indexPath.row] = -1, the likes should be subtract 1
                if (eventListlikes[indexPath.row] == -1){
                    let evendislikes = Int(events[indexPath.row].dislikes)! - number
                    events[indexPath.row].dislikes = String(evendislikes)
                    allevents[indexPath.row].dislikes = String(evendislikes)
                    
                }
                indexlikes[indexPath.row] = 1
                eventListlikes[indexPath.row] = 1
                let eventlikes = Int(events[indexPath.row].likes)! + number
                
                events[indexPath.row].likes = String(eventlikes)
                allevents[indexPath.row].likes = String(eventlikes)
                record.change(indexPath.row, indexlikes[indexPath.row], indexList[indexPath.row] )
                
               

                if (postBool){
                    
                    self.postLikes(rating: "like", postID: Int(events[indexPath.row].id)!, postLikes: Int(events[indexPath.row].likes)!, postDislikes: Int(events[indexPath.row].dislikes)!)
                    
                }
                self.tableView.reloadData()
                
            }
            
        }
        action.backgroundColor = .red
        return action
    }
    
    
    // post the likes or dislikes to the server
    func postLikes(rating: String, postID: Int, postLikes: Int, postDislikes: Int){
        let parameters = ["result": "success", "id": postID, "likes": postLikes, "dislikes": postDislikes] as [String : Any]
        
        guard  let url = URL(string: "http://partiklezoo.com/fringer/?action=rate&rating=\(rating)&id=\(String(postID))") else {
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

extension EventListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventListViewCell
        
        cell.setIndexCell(newIndexCell: indexPath.row)
        
       
        cell.setCellWithValueOf(events[indexPath.row], allimages[indexPath.row])
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dislike = dislikeAction(at: indexPath)
        return  UISwipeActionsConfiguration(actions: [dislike])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let like = likeAction(at: indexPath)
        return  UISwipeActionsConfiguration(actions: [like])
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "segue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DescriptionEventCV {

            destination.event = events[(tableView.indexPathForSelectedRow?.row)!]
//            destination.venueModel = venuesModel
            destination.displayIndex = (tableView.indexPathForSelectedRow?.row)!
            destination.delegate = self
            destination.listEvent = allevents
            
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
           
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){}
    

}

extension EventListViewController: DescriptionEventCVDelegate{
    func didSetEvents(_ newEvents: [Events]) {
        events = newEvents
    }
    
    func refreshTableView() {
        self.tableView.reloadData()
        
    }
    
    
    
}
