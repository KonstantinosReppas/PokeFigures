//
//  PokemonDetailsViewController.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 21/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import UIKit
import SDWebImage

class PokemonDetailsViewController: UIViewController {
    
    var pokemonModel: PokemonModel?
    
    @IBOutlet weak var pokemonImageview: UIImageView!
    @IBOutlet weak var pokemonNameImageView: UILabel!
    @IBOutlet weak var topViewLayout: UIView!
    @IBOutlet weak var typesListLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topViewLayout.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        topViewLayout.clipsToBounds = true
        topViewLayout.layer.cornerRadius = 20
        
        typesListLabel.text = "Fire\nWater"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pokemonNameImageView.text = pokemonModel?.name
        if pokemonModel?.imageUrl != nil, let url = URL(string: pokemonModel?.imageUrl ?? ""){

            pokemonImageview?.sd_setImage(with: url, completed: nil)
        }
    }

    @IBAction func onBackPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
