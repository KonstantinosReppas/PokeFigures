//
//  ChoosePokemonCollectionViewCell.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 20/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import UIKit

class ChoosePokemonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pokemonImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pokemonImage.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        pokemonImage.clipsToBounds = true
        pokemonImage.layer.cornerRadius = 20
    }

}
