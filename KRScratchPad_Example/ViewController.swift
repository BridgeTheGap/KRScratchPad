//
//  ViewController.swift
//  ScratchPad
//
//  Created by Joshua Park on 31/08/2017.
//  Copyright © 2017 Knowre. All rights reserved.
//

import UIKit
import KRScratchPad

class ViewController: UIViewController {
    
    @IBOutlet weak var scratchPad: ScratchPad!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rotateColorAction(_ sender: Any) {
        switch scratchPad.lineColor {
        case UIColor.red:
            scratchPad.lineColor = UIColor.blue
        case UIColor.blue:
            scratchPad.lineColor = UIColor.black
        default:
            scratchPad.lineColor = UIColor.red
        }
    }
    
    @IBAction func rotateWidthAction(_ sender: Any) {
        switch scratchPad.lineWidth {
        case 1.5:
            scratchPad.lineWidth = 3.0
        case 3.0:
            scratchPad.lineWidth = 4.5
        default:
            scratchPad.lineWidth = 1.5
        }
    }
    
    @IBAction func toggleDraw(_ sender: Any) {
        scratchPad.isDrawingMode = true
    }
    
    @IBAction func toggleErase(_ sender: Any) {
        scratchPad.isDrawingMode = false
    }
}

