//
//  GameStartViewController.swift
//  game
//
//  Created by yesway on 2016/10/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

class GameStartViewController: UIViewController {

    var onButtonTap: ((Void) -> Void)?
    
    @IBAction func tap(_ sender: UIButton) {
        onButtonTap?()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
