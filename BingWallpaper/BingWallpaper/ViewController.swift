//
//  ViewController.swift
//  BingWallpaper
//
//  Created by Junna on 11/25/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var model: ViewModel?
    
    lazy var progressor: NSProgressIndicator = {
        let pro = NSProgressIndicator(frame: self.view.frame)
        pro.style = .SpinningStyle
        return pro
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = ViewModel()
        model?.delegate = self
        model?.loadViewModel()
        self.view.addSubview(progressor)
        progressor.startAnimation(nil)
    }
    
    func reload() {
        progressor.stopAnimation(nil)
        progressor.removeFromSuperview()
        
        if let viewModel = model {
            let workspace   = NSWorkspace.sharedWorkspace()
            let screen      = NSScreen.mainScreen()
            do {
                if let url = viewModel.wallPaperURL {
                    print("WallPaper: \(url)")
                    try workspace.setDesktopImageURL(url, forScreen: screen!, options: [:])
                }
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
        }
    }
    
    func addLoadingView() {
        self.view.addSubview(progressor)
        progressor.startAnimation(nil)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

