//
//  EventListViewCell.swift
//  Adelaide Fringe
//
//  Created by Fan Liang on 17/10/20.
//

import UIKit





class EventListViewCell: UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    
    @IBOutlet weak var venue: UILabel!
    
    

    
    @IBOutlet weak var eventDescription: UILabel!
    
    
    @IBOutlet weak var likes: UILabel!
    
    @IBOutlet weak var dislikes: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    var indexCell = 0
    
    
    
    
    
    
    
    func setCellWithValueOf(_ event:Events, _ newImage:UIImage){
        updateCell(event.name, event.artist, event.venue, event.description, event.likes, event.dislikes, event.image)
        setCellImage(newImage)
       
        
        
    }
    
    func updateCell(_ newname:String, _ newartist:String, _ newvenue:String, _ newDescription:String, _ newlikes:String, _ newdislikes:String, _ newImage:String ){
        
        name.text = "Name: " + newname
        artist.text = "Artist: " + newartist
        venue.text = "Venue: " + newvenue
        eventDescription.text = newDescription

        
        likes.text = newlikes
        dislikes.text = newdislikes
        
        
        
        
    }
    
    func setCellImage(_ newImage:UIImage) {
        cellImage.image = newImage
    }

    

    

   
    func setIndexCell(newIndexCell: Int){
        indexCell = newIndexCell
    }
    
    
    
}
