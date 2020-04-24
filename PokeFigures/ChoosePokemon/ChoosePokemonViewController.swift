//
//  ViewController.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 20/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import UIKit

class ChoosePokemonViewController: UIViewController, ChoosePokemonCellDelegate, GenerationFiltersDelegate {
    
    @IBOutlet weak var pokemonCollectionView: UICollectionView!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var filtersStackView: UIStackView!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    @IBAction func onScrollSeek(_ sender: UISlider) {
        pokemonCollectionView.scrollToItem(at: IndexPath(item: Int(sender.value * Float((pokemonList.count-1))), section: 0), at: .centeredHorizontally, animated: true)
    }
    
    let fetchPokemonUseCase = FetchPokemonUseCase()
    var filterHandler = GenerationFiltersHandler()
    
    var pokemonList = [PokemonModel]()
    
    let transition = TransitionAnimator()
    var transitionSourceView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleViewStyling()
        
        setupPokemonCollectionViewCells()
        
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.delegate = self
        
        fetchData()
        
        filterHandler.setupFilters(buttons: filtersStackView.subviews as! [UIButton])
        filterHandler.generationFiltersDelegate = self
        
        hanndleReturnFromDetailsAnimation()
    }
    
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
    
    fileprivate func fetchData(generation: Int = 0) {
        fetchPokemonUseCase.fetchPokemonAndNotify(generation: generation, resultsCallback: { pokemonList in
            
            DispatchQueue.main.async {
                
                self.pokemonList.removeAll()
                self.pokemonCollectionView.reloadData()
                
                self.pokemonCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                self.seekSlider.value = 0
                
                self.pokemonList = pokemonList
                self.pokemonCollectionView.reloadData()
                
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.resizeCells), userInfo: nil, repeats: false)
            }
            
        })
    }
    
    
    fileprivate func hanndleReturnFromDetailsAnimation() {
        transition.dismissCompletion = {
            self.transitionSourceView.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                self.transitionSourceView.transform = .identity
            }) { _ in
                self.transitionSourceView.tintColor = .label
            }
        }
    }
    
    func onPlayClicked(view: UIButton) {
        view.tintColor = .blue
        transitionSourceView = view
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.transitionSourceView.transform = CGAffineTransform(translationX: 25, y: -20).concatenating(CGAffineTransform(scaleX: 2, y: 2))
        }){ _ in
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
    
    func filterClicked(gen: Int) {
        fetchData(generation: gen)
    }
    
}
