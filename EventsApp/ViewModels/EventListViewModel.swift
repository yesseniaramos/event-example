//
//  EventListViewModel.swift
//  EventsApp
//
//  Created by yessenia ramos on 25/05/23.
//

import Foundation

final class EventListViewModel {
    
    let title = "Events"
    var coordinator: EventListCoordinator?
    var onUpdate = {}
    
    enum Cell {
        case event(EventCellViewModel)
    }
    
    private(set) var cells: [Cell] = []
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
    }
    
    func viewDidLoad() {
        // One thing to note is thath this is all done on the main thread, so
        // if you've got hundreds of events etc this might be pretty slow 
        reload()
    }
    
    func reload() {
        
        // in the future fix to remove from cache only the image updated
        EventCellViewModel.imageCache.removeAllObjects()
        let events = eventService.getEvents()
         
        self.cells = events.map {
            var eventCellViewModel = EventCellViewModel($0)
            if let coordinator = coordinator {
                eventCellViewModel.onSelect = coordinator.onSelect
            }
            return .event(eventCellViewModel)
        }
        onUpdate()
    }
    
    func tappedAppEvent() {
        coordinator?.startAddEvent()
    }
    
    func numberOfRows() -> Int {
        return cells.count
    }
    
    func cell(at indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .event(let eventCellViewModel):
            eventCellViewModel.didSelect()
        }
    }
    
}
