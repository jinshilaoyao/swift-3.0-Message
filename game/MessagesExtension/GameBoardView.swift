//
//  GameBoardView.swift
//  game
//
//  Created by yesway on 2016/10/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

class GameBoardView: UICollectionView {
    
    enum CellStyle {
        case selectedGreed
        case selectedRed
        case deSelected
    }
    
    fileprivate var cellStyles = Array(repeating: CellStyle.deSelected, count: 100)
    
    var onCellSelecttion: ((Int) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "gameCell")
        
        dataSource = self
        delegate = self
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
    }
}

extension GameBoardView {
    
    func reset() {
        cellStyles = Array(repeating: CellStyle.deSelected, count: 100)
        reloadData()
//        layoutIfNeeded()
    }
    
    var selectedCells: [Int] {
        var cells = [Int]()
        
        for (index, selected) in cellStyles.enumerated() where selected == .selectedGreed || selected == .selectedRed{
            cells.append(index)
        }
        
        return cells
    }
    
    func toggleCellStyle(at cellIndex: Int) {

        let style: CellStyle = (cellStyles[cellIndex] == .selectedGreed) ? .deSelected : .selectedGreed
        alterCell(at: cellIndex, applying: style)
    }

    
    func alterCell(at index: Int, applying selectionStyle: CellStyle) {
        cellStyles[index] = selectionStyle
        let path = IndexPath(row: index, section: 0)
        
        let cell = cellForItem(at: path)!
        decorate(cell, for: selectionStyle)
    }
    
    fileprivate func decorate(_ cell: UICollectionViewCell, for style: CellStyle) {
        switch style {
        case .selectedGreed:
            cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .selectedRed:
            cell.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case .deSelected:
            cell.backgroundColor = UIColor(red:0.33, green:0.43, blue:0.54, alpha:1.00)
        }
    }
}

extension GameBoardView: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        
        decorate(cell, for: cellStyles[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        onCellSelecttion?(indexPath.item)
    }
}
extension GameBoardView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsPerRow: CGFloat = 10
        let perimeterLength = floor(superview!.bounds.width / cellsPerRow)
        
        return CGSize(width: perimeterLength, height: perimeterLength)
    }
}

