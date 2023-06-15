//
//  PreStartViewController.swift
//  Places
//
//  Created by Matthias Wortmann on 27.06.16.
//  Copyright © 2016 Matthias Wortmann. All rights reserved.
//

import UIKit

class PreStartViewController: UIViewController {

    @IBOutlet weak var progressView: MKActivityIndicator!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.startAnimating()
    }

}
