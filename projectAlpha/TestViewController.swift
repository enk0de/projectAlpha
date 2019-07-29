//
//  TestViewController.swift
//  projectAlpha
//
//  Created by Mac on 28/07/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import FloatingPanel

class TestViewController: UIViewController, FloatingPanelControllerDelegate {

    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fpc = FloatingPanelController()
        
        // Assign self as the delegate of the controller.
        fpc.delegate = self // Optional
        
        // Set a content view controller.
        let contentVC = RecordedListViewController()
        fpc.set(contentViewController: contentVC)
        
        
        // Add and show the views managed by the `FloatingPanelController` object to self.view.
        fpc.addPanel(toParent: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove the views managed by the `FloatingPanelController` object from self.view.
        fpc.removePanelFromParent(animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
