//
//  ViewController.swift
//  DYMAssistiveTouchDemo
//
//  Created by Bean on 15/9/10.
//  Copyright (c) 2015年 Bean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        DYMAssistiveTouchView.showInViewController(self);
    }

    @IBAction func addAction(sender: AnyObject) {
        DYMAssistiveTouchView.showInViewController(self);
    }
    @IBAction func dismissAction(sender: AnyObject) {
        DYMAssistiveTouchView.dismiss()
    }

    @IBAction func appearAction(sender: AnyObject) {
        DYMAssistiveTouchView.didAppear(true)
    }
    @IBAction func disappearAction(sender: AnyObject) {
        DYMAssistiveTouchView.didDisappear(true)
    }
}

