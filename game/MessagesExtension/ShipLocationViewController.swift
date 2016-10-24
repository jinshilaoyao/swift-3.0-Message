//
//  ShipLocationViewController.swift
//  game
//
//  Created by yesway on 2016/10/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

class ShipLocationViewController: UIViewController {

    @IBOutlet weak var gameBoardView: GameBoardView!
    @IBOutlet weak var finishButton: UIButton!
    
    var onLocationSelectionComplete: ((GameModel, UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameBoardView.onCellSelecttion = { [unowned self] cellLocation in
            
            self.gameBoardView.toggleCellStyle(at: cellLocation)
            self.updateLabels()
            
        }
    }

    @IBAction func onFinishTap(_ sender: UIButton) {
        
        let model = GameModel(shipLocations: [1], isComplete: false, gamerStyle: .Creater)
        
        onLocationSelectionComplete?(model, UIImage.snapshot(from: gameBoardView))
        
    }
    
    func updateLabels() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ShipLocationViewController {
    
    fileprivate var shipsLeftToPosition: Int {
        
        return 0
    }
    
}
