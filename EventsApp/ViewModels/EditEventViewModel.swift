//
//  EditEventViewModel.swift
//  EventsApp
//
//  Created by yessenia ramos on 31/10/23.
//

import UIKit

final class EditEventViewModel {
    
    let title = "Edit"
    var onUpdate: () -> Void = {}
    
    enum Cell {
        case titleSubtitle(TitleSubtitleCellViewModel)
    }
    
    private(set) var cells: [Cell] = []
     
    weak var coordinator: EditEventCoordinator?
    
    private var nameCellViewModel: TitleSubtitleCellViewModel?
    private var dateCellViewModel: TitleSubtitleCellViewModel?
    private var backgroundImageCellViewModel: TitleSubtitleCellViewModel?
    private let cellBuilder: EventsCellBuilder
    private let eventService: EventServiceProtocol
    private let event: Event
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyy"
        return dateFormatter
    }()
    
    init(event: Event,
        cellBuilder: EventsCellBuilder,
         eventService: EventServiceProtocol = EventService()) {
        self.event = event
        self.cellBuilder = cellBuilder
        self.eventService = eventService
    }
    
    func viewDidLoad() {
        setupCells()
        onUpdate()
    }
    
    func viewDidDisappear() {
        coordinator?.didFinish()
    }
    
    func numberOfRows() -> Int {
        return cells.count
    }
    
    func cell(for indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }
    
    func tappedDone() {
        guard
            let name = nameCellViewModel?.subtitle,
            let dateString = dateCellViewModel?.subtitle,
            let image = backgroundImageCellViewModel?.image,
            let date = dateFormatter.date(from: dateString)
            else { return }
        
        eventService.perform(
            .update(event), 
            data: EventService.EventInputData(
            name: name,
            date: date,
            image: image
            )
        )
        coordinator?.didFinishUpdateEvent()
    }
    func updateCell(indexPath: IndexPath, subtitle: String) {
        switch cells[indexPath.row] {
        case .titleSubtitle(let titleSubtitleCellViewModel):
            titleSubtitleCellViewModel.update(subtitle)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath){
        switch cells[indexPath.row] {
        case .titleSubtitle(let titleSubtitleCellViewModel):
            guard titleSubtitleCellViewModel.type == .image else {
                return
            }
            
            coordinator?.showImagePicker { image in
                titleSubtitleCellViewModel.update(image)
            }
        }
    }
    
    deinit {
        print("deinit from add event view model")
        print("add event view model has been deallocated")
    }
}

private extension EditEventViewModel {
    func setupCells () {
        nameCellViewModel = cellBuilder.makeTitleSubtitleCellViewModel(.text)
        dateCellViewModel = cellBuilder.makeTitleSubtitleCellViewModel(.date) { [weak self] in
            self?.onUpdate()
        }
        backgroundImageCellViewModel = cellBuilder.makeTitleSubtitleCellViewModel(.image) { [weak self] in
            self?.onUpdate()
        }
        
        guard let nameCellViewModel = nameCellViewModel, let dateCellViewModel = dateCellViewModel, let backgroundImageCellViewModel = backgroundImageCellViewModel else { return }
        
        cells = [
            .titleSubtitle(
                nameCellViewModel
            ),
            .titleSubtitle(
                dateCellViewModel
            ),
            .titleSubtitle(
                backgroundImageCellViewModel
            )
        ]
        
        guard let name = event.name,
                let date = event.date,
                let imagedata = event.image,
                let image = UIImage(data: imagedata)
        else { return }
        
        nameCellViewModel.update(name)
        dateCellViewModel.update(date)
        backgroundImageCellViewModel.update(image)
    }
}
