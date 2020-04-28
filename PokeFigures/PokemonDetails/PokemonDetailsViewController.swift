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
    @IBOutlet weak var statsListLabel: UILabel!
    
    private let mPokemonDetailsUseCase = FetchPokemonDetailsUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topViewLayout.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        topViewLayout.clipsToBounds = true
        topViewLayout.layer.cornerRadius = 20

        mPokemonDetailsUseCase.fetchPokemonDetailsAndNotify(id: pokemonModel?.number ?? 0) { (pokemonDetailsModel) in
            DispatchQueue.main.async {
                for i in 0..<pokemonDetailsModel.types.count {
                    self.typesListLabel.text?.append(pokemonDetailsModel.types[i].type.name + "\n")
                }
                for i in 0..<pokemonDetailsModel.stats.count {
                    self.statsListLabel.text?.append(pokemonDetailsModel.stats[i].stat.name + ": " + String(pokemonDetailsModel.stats[i].base_stat) + "\n")
                }
                
            }
        }
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
