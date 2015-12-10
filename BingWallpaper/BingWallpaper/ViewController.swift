//
//  ViewController.swift
//  BingWallpaper
//
//  Created by Junna on 11/25/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var model: FlickrViewModel?
    
    @IBOutlet weak var textField: NSTextField!
    lazy var progressor: NSProgressIndicator = {
        let pro = NSProgressIndicator(frame: self.view.frame)
        pro.style = .SpinningStyle
        return pro
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = FlickrViewModel()
        model?.delegate = self
        model?.loadViewModel()
        self.view.addSubview(progressor)
        progressor.startAnimation(nil)
        
        NSTimer.scheduledTimerWithTimeInterval(15 * 60, target: self, selector: "reload", userInfo: nil, repeats: true)
    }
    
    func reload() {
        progressor.stopAnimation(nil)
        progressor.removeFromSuperview()
        
        if let viewModel = model {
            let workspace   = NSWorkspace.sharedWorkspace()
            let screen      = NSScreen.mainScreen()
            do {
                if let url = viewModel.wallPaperURL() {
                    textField.stringValue = "\(textField.stringValue)\n更新图片: \(url)"
                    print("WallPaper: \(url)")
                    try workspace.setDesktopImageURL(url, forScreen: screen!, options: [:])
                }
                viewModel.fetchNextPhoto()
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

