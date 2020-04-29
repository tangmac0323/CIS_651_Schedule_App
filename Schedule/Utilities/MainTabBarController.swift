//
//  MainTabBarController.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController : UITabBarController {
    
    @IBOutlet weak var MainTabBar: UITabBar!
    
    /*
    let persistenceManager: PersistenceManager
    
    init(persistenceManager : PersistenceManager) {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        //super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 1
    }
    
}
