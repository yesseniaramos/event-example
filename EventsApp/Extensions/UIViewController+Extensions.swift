//
//  UIViewController+Extensions.swift
//  EventsApp
//
//  Created by yessenia ramos on 26/05/23.
//

import UIKit


extension UIViewController {
    static func instantiate<T>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let controller = storyboard.instantiateViewController(identifier:
                                                                "\(T.self)") as! T
        
        return controller
    }
}
