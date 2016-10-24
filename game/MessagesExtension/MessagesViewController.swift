//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by yesway on 2016/10/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import Messages



class MessagesViewController: MSMessagesAppViewController {
    
    struct GameConstants {
        /// 一共需要布置的战舰数
        static let totalShipCount = 2
        /// 允许玩家 B 失败的次数
        static let incorrectAttemptsAllowed = 3
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        
        configureChildViewController(for: presentationStyle, with: conversation)
        
    }
    
    private func configureChildViewController(for presentationStyle: MSMessagesAppPresentationStyle, with conversation: MSConversation) {
        
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        var childController: UIViewController
        
        switch presentationStyle {
        case .compact:
            childController = creatGameStartViewController()
            break
        case .expanded:
            if let message = conversation.selectedMessage, let url = message.url {
                let model = GameModel(from: url, gamer: .Player)
                childController = createShipDestroyViewController(with: conversation, model: model)
            } else {
                childController = createShipLocationViewController(with: conversation)
            }
            break
        }
        
        // 添加子 view controller
        addChildViewController(childController)
        childController.view.frame = view.bounds
        childController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childController.view)
        
        childController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        childController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        childController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        childController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        childController.didMove(toParentViewController: self)
        
    }
        
    private func createShipLocationViewController(with conversation: MSConversation) -> UIViewController {
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ShipLocationViewController") as? ShipLocationViewController else {
            fatalError("Cannot instantiate view controller")
        }
        
        
        controller.onLocationSelectionComplete = { [unowned self] model, image  in
            
            let session = MSSession()
            let caption = "haha"
            
            self.insertMessageWith(caption: caption, model, session, image, in: conversation)
            
            self.dismiss()
            
        }
        
        
        return controller
    }

    private func createShipDestroyViewController(with conversation: MSConversation, model: GameModel) -> UIViewController {
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ShipDestroyViewController") as? ShipDestroyViewController else {
            fatalError("Cannot instantiate view controller")
        }
        
        controller.gameModel = model
        controller.onGameCompletion = {
            [unowned self]
            model, playerWon, snapshot in
            
            if let message = conversation.selectedMessage,
                let session = message.session {
                let player = "$\(conversation.localParticipantIdentifier)"
                let caption = playerWon ? "\(player) destroyed all the ships!" : "\(player) lost!"
                
                self.insertMessageWith(caption: caption, model, session, snapshot, in: conversation)
            }
            
            self.dismiss()
        }

        
        return controller
        
    }
    
    private func creatGameStartViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "GameStartViewController") as? GameStartViewController else {
            fatalError("")
        }
        controller.onButtonTap = { [unowned self] in
            self.requestPresentationStyle(.expanded)
        }
        
        return controller
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        
        guard let conversation = self.activeConversation else { return }
        configureChildViewController(for: presentationStyle, with: conversation)
        
    }
    
    func insertMessageWith(caption: String,
                           _ model: GameModel,
                           _ session: MSSession,
                           _ image: UIImage,
                           in conversation: MSConversation) {
        let message = MSMessage(session: session)
        let template = MSMessageTemplateLayout()
        template.image = image
        template.caption = caption
        message.layout = template
        message.url = model.encode()
        
        // Now we've constructed the message, insert it into the conversation
        conversation.insert(message)
    }

    

}
