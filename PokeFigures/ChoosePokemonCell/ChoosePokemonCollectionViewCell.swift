//
//  ChoosePokemonCollectionViewCell.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 20/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import UIKit
import SDWebImage

class ChoosePokemonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 20
    }

    func bindData(pokemon: PokemonModel) {
        
        pokemonNameLabel.text = pokemon.name
        if pokemon.imageUrl != nil, let url = URL(string: pokemon.imageUrl!){

            pokemonImage.sd_setImage(with: url, completed: nil)
        }
    }
}
