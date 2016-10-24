//
//  ShipDestroyViewController.swift
//  game
//
//  Created by yesway on 2016/10/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

class ShipDestroyViewController: UIViewController {

    @IBOutlet weak var gameBoard: GameBoardView!
    @IBOutlet weak var attemptLabel: UILabel!
    
    var gameModel: GameModel!
    
    var onGameCompletion: ((GameModel, Bool, UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gameModel.isComplete {
            let alert = UIAlertController(title: "Game Complete!", message: "The game's already finished!", preferredStyle: .alert)
            present(alert, animated: true)
            gameBoard.isHidden = true
            return
        }
        
        gameBoard.onCellSelecttion = { [unowned self] cellLocation in
            if self.gameModel.shipLocations.contains(cellLocation) {
                self.gameBoard.alterCell(at: cellLocation, applying: .selectedGreed)
            } else {
                self.gameBoard.alterCell(at: cellLocation, applying: .selectedRed)
            }
            
            self.updateLabels()
            self.checkGameCompletion()
        }


        // Do any additional setup after loading the view.
    }
    
    func updateLabels() {
        
    }
    
    func checkGameCompletion() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
