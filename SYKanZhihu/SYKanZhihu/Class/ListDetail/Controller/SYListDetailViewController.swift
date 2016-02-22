//
//  SYListDetailViewController.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/22.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYListDetailViewController: UIViewController {

    var requestDate = ""
    var requestState = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

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
