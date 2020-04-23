//
//  ViewController.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 20/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import UIKit

class ChoosePokemonViewController: UIViewController {
    
    @IBOutlet weak var pokemonCollectionView: UICollectionView!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var filtersStackView: UIStackView!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    
    let fetchPokemonUseCase = FetchPokemonUseCase()
    var filterHandler = GenerationFiltersHandler()
    
    var pokemonList = [PokemonModel]()
    
    fileprivate func setupPokemonCollectionViewCells() {
        let pokemonCellNib = UINib(nibName: "ChoosePokemonCollectionViewCell", bundle: nil)
        pokemonCollectionView.register(pokemonCellNib, forCellWithReuseIdentifier: "ChoosePokemonCollectionViewCell")
    }
    
    fileprivate func handleViewStyling() {
        
        pokemonCollectionView.showsHorizontalScrollIndicator = false
        let padding = pokemonCollectionView.bounds.size.width * CGFloat(((1 - C.POKEMON_CELL_WIDTH_PERCENTAGE) * 0.5))
        pokemonCollectionView.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        filtersScrollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        filtersStackView.clipsToBounds = false
    }
    
    fileprivate func fetchData() {
        fetchPokemonUseCase.fetchPokemonAndNotify(resultsCallback: { pokemonList in
            
            DispatchQueue.main.async {
                
                self.pokemonList = pokemonList
                self.pokemonCollectionView.reloadData()
                
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.resizeCells), userInfo: nil, repeats: false)
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleViewStyling()
        
        setupPokemonCollectionViewCells()
        
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.delegate = self
        
        fetchData()
        
        filterHandler.setupFilters(buttons: filtersStackView.subviews as! [UIButton])
    }
    
    
    @IBAction func onScrollSeek(_ sender: UISlider) {
        pokemonCollectionView.scrollToItem(at: IndexPath(item: Int(sender.value * Float((pokemonList.count-1))), section: 0), at: .centeredHorizontally, animated: true)
        
    }
}

