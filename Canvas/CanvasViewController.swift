//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Pat Boonyarittipong on 5/4/15.
//  Copyright (c) 2015 patboony. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {


    @IBOutlet weak var trayView: UIView!
    
    var trayCurrentCenter: CGPoint!
    var trayUpCenter: CGPoint!
    var trayDownCenter: CGPoint!
    var newlyCreatedFace: UIImageView!
    var faceOriginalCenter: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trayCurrentCenter = trayView.center
        trayUpCenter = trayCurrentCenter
        trayDownCenter = CGPoint(x: trayCurrentCenter.x, y: 640)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func moveFace(sender: AnyObject) {
        
        if sender.state == UIGestureRecognizerState.Began {
            var senderImageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: senderImageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = senderImageView.center
            // Offset the corrdinates since the original face is in a tray
            newlyCreatedFace.center.y += trayView.frame.origin.y
            faceOriginalCenter = newlyCreatedFace.center
            
            // Increase the size
            UIView.animateWithDuration(0.15, animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(2.0, 2.0)
            })
            
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            var translation = sender.translationInView(view)
            newlyCreatedFace.center.x = faceOriginalCenter.x + translation.x
            newlyCreatedFace.center.y = faceOriginalCenter.y + translation.y

        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
        }
        

    }
    
  
    @IBAction func onTrayPanGesture(sender: UIPanGestureRecognizer) {
        
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            // Make sure the tray doesn't go higher than the "up" position
            if trayCurrentCenter.y + translation.y >= trayUpCenter.y {
                trayView.center = CGPoint(x: trayCurrentCenter.x, y: trayCurrentCenter.y + translation.y)
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            if velocity.y > 0 {
                animateTray(true)
            } else {
                animateTray(false)
            }
        }

        // How do we reset trayOriginalCenter when the pan is over?
        
    }
    
    func animateTray(directionIsDown: Bool){
        if directionIsDown {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
                self.trayView.center = self.trayDownCenter
            }, completion: { (Bool) -> Void in
                self.trayCurrentCenter = self.trayView.center
            })
            
        } else {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
                self.trayView.center = self.trayUpCenter
                }, completion: { (Bool) -> Void in
                    self.trayCurrentCenter = self.trayView.center
            })
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
