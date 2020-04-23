//
//  GenerationFiltersHandler.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 23/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import Foundation
import UIKit

class GenerationFiltersHandler {
    
    var filterButtons = [UIButton]()
    
    var generationFiltersDelegate: GenerationFiltersDelegate?
    
    var previousSelectedFilter = 0
    
    func setupFilters(buttons: [UIButton]) {
        
        filterButtons.append(contentsOf: buttons)
        for i in 0..<filterButtons.count {
            let button = filterButtons[i]
            button.tag = i
            button.setTitle("Generation " + String(i + 1), for: .normal)
            button.layer.cornerRadius = 8
            button.setTitleColor(.secondaryLabel, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        }
        filterButtons[0].isSelected = true
    }
    
    @objc func buttonClicked(_ sender: AnyObject?) {
        
        
        if let tag = sender?.tag, tag != previousSelectedFilter{
            filterButtons[previousSelectedFilter].isSelected = false
            filterButtons[tag].isSelected = true
            previousSelectedFilter = tag
            generationFiltersDelegate?.filterClicked(gen: tag + 1)
        }
    }
}

protocol GenerationFiltersDelegate {
    func filterClicked(gen: Int)
}
