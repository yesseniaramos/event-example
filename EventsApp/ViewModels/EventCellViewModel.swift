//
//  EventCellViewModel.swift
//  EventsApp
//
//  Created by yessenia ramos on 20/06/23.
//

import UIKit
import CoreData

struct EventCellViewModel {
    let date = Date()
    
    static let imageCache = NSCache<NSString, UIImage>()
    private let imageQueue = DispatchQueue(label: "imageQueue", qos: .background)
    var onSelect: (NSManagedObjectID) -> Void = { _ in }
    
    private var cacheKey: String {
        event.objectID.description
    }
    
    var timeRemainingString: [String] {
        // 1 year, 1 month, 2 weeks, 1 day
        guard let eventDate = event.date else {return []}
        //1 year, 2 months
        return date.timeRemaining(until: eventDate)?.components(separatedBy: ",") ?? []
    }
    
    var dateText: String? {
        guard let eventDate = event.date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yy "
        return dateFormatter.string(from: eventDate)
    }
    
    var eventName: String? {
        event.name
    }
    
    var timeRemainingViewModel: TimeRemainingViewModel? {
        guard let eventDate = event.date, let timeRemainingParts = date.timeRemaining(until: eventDate)?.components(separatedBy: ",") else { return nil }
        return TimeRemainingViewModel(timeRemainingParts: timeRemainingParts, mode: .cell)
    }
    
    func loadImage(completion: @escaping(UIImage?) -> Void ) {
        // check image cache for a value of the cache key and complet with this image value
        if let image = Self.imageCache.object(forKey: cacheKey as NSString) {
            completion(image)
        }
        else {
            imageQueue.async {
                guard let imageData = self.event.image, let image = UIImage(data: imageData) else {
                    completion(nil)
                    return
                }
                Self.imageCache.setObject(image, forKey: self.cacheKey as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    
    /*var backgroundImage: UIImage {
        guard let imageData = event.image else { return UIImage() }
        return UIImage(data: imageData) ?? UIImage()
    }*/
    
    func didSelect(){
        onSelect(event.objectID)
    }
    
    private let event: Event
    init(_ event: Event) {
        self.event = event
    }
}
 
