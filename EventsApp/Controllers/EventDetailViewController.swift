//
//  EventDetailVoewController.swift
//  EventsApp
//
//  Created by yessenia ramos on 17/10/23.
//

import UIKit

final class EventDetailViewController: UIViewController {
    
    
    @IBOutlet weak var timeRemainingStackView: TimeRemainingStackView! {
        didSet {
            timeRemainingStackView.setup()
        }
    }
    @IBOutlet weak var backgroundImageView: UIImageView!
    var  viewModel: EventDetailViewModel!
    
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onUpdate = {[weak self] in
            guard let self = self, let timeRemainingViewModel = viewModel.timeRemainingViewModel else { return }
            self.backgroundImageView.image = self.viewModel.image
            //time remaining label
            self.timeRemainingStackView.update(with: timeRemainingViewModel)
            // event name and date label
        }
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "pencil"), style: .plain, target: viewModel, action: #selector(viewModel.editButtonTapped))
        
        viewModel.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
}
