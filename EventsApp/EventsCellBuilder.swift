//
//  EventsCellBuilder.swift
//  EventsApp
//
//  Created by yessenia ramos on 16/06/23.
//

import Foundation

struct EventsCellBuilder {
    func makeTitleSubtitleCellViewModel(
        _ type: TitleSubtitleCellViewModel.CellType,
        onCellUpdate: (() -> Void)? = nil
    ) -> TitleSubtitleCellViewModel {
        switch type {
        case .text:
            return TitleSubtitleCellViewModel(
                title: "Name",
                subtitle: "",
                placeholder: "Add a name",
                type:  .text,
                onCellUpdate: onCellUpdate
            )
        case .date:
            return TitleSubtitleCellViewModel(
                title: "Date",
                subtitle: "",
                placeholder: "Select a date",
                type: .date,
                onCellUpdate: onCellUpdate
            )
        case .image:
            return TitleSubtitleCellViewModel(
                title: "Background",
                subtitle: "",
                placeholder: "Select an image",
                type: .image,
                onCellUpdate: onCellUpdate
            )
        }
    }
}
