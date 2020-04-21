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
    
    let fetchPokemonUseCase = FetchPokemonUseCase()
    
    var pokemonList = [PokemonModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pokemonCollectionView.showsHorizontalScrollIndicator = false
        let padding = pokemonCollectionView.bounds.size.width * CGFloat(((1 - C.POKEMON_CELL_WIDTH_PERCENTAGE) * 0.5))
        pokemonCollectionView.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        
        let pokemonCellNib = UINib(nibName: "ChoosePokemonCollectionViewCell", bundle: nil)
        pokemonCollectionView.register(pokemonCellNib, forCellWithReuseIdentifier: "ChoosePokemonCollectionViewCell")
        
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.delegate = self
        
        fetchPokemonUseCase.fetchPokemonAndNotify(resultsCallback: { pokemonList in
            
            DispatchQueue.main.async {

                self.pokemonList = pokemonList
                self.pokemonCollectionView.reloadData()
                
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.resizeCells), userInfo: nil, repeats: false)
            }
            
        })
    }
}

extension ChoosePokemonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoosePokemonCollectionViewCell", for: indexPath)
        
        (cell as? ChoosePokemonCollectionViewCell)?.bindData(pokemon: pokemonList[indexPath.row])
        
        return cell
    }
    
}

extension ChoosePokemonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width * CGFloat(C.POKEMON_CELL_WIDTH_PERCENTAGE), height: collectionView.bounds.size.height * 0.95)
    }
}

extension ChoosePokemonViewController : UIScrollViewDelegate {
    // perform scaling whenever the collection view is being scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        resizeCells()
    }
    
    // for custom snap-to paging, when user stop scrolling
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        var indexOfCellWithLargestWidth = 0
        var largestWidth : CGFloat = 1
        
        for cell in pokemonCollectionView.visibleCells {
            if cell.frame.size.width > largestWidth {
                largestWidth = cell.frame.size.width
                if let indexPath = pokemonCollectionView.indexPath(for: cell) {
                    indexOfCellWithLargestWidth = indexPath.item
                }
            }
        }
        
        pokemonCollectionView.scrollToItem(at: IndexPath(item: indexOfCellWithLargestWidth, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func resizeCells() {
        // center X of collection View
        let centerX = self.pokemonCollectionView.center.x
        
        // only perform the scaling on cells that are visible on screen
        for cell in self.pokemonCollectionView.visibleCells {
            
            
            
            // coordinate of the cell in the viewcontroller's root view coordinate space
            let basePosition = cell.convert(CGPoint.zero, to: self.view)
            let cellCenterX = basePosition.x + self.pokemonCollectionView.frame.size.width / 2
            
            let distance = abs(cellCenterX - centerX)
            
            let tolerance : CGFloat = 0.02
            var scaleY = 1.00 + tolerance - (( distance / centerX) * 0.09)
            if(scaleY > 1.0){
                scaleY = 1.0
            }
            
            var scaleX = 1.00 + tolerance - (( distance / centerX) * 0.035)
            if(scaleX > 1.0){
                scaleX = 1.0
            }
            
            print( String(Float(distance)))
            
            // Transform the cell size based on the scale
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }
    }
}
