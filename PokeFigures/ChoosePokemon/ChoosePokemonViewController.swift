//
//  ViewController.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 20/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import UIKit

class ChoosePokemonViewController: UIViewController, ChoosePokemonCellDelegate {
    func onPlayClicked(view: UIView) {
        viewForAnimation = view
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    @IBOutlet weak var pokemonCollectionView: UICollectionView!
    @IBOutlet weak var seekSlider: UISlider!
    
    var viewForAnimation: UIView?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    
    @IBAction func onScrollSeek(_ sender: UISlider) {
        pokemonCollectionView.scrollToItem(at: IndexPath(item: Int(sender.value * Float((pokemonList.count-1))), section: 0), at: .centeredHorizontally, animated: true)
        
    }
}

extension ChoosePokemonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoosePokemonCollectionViewCell", for: indexPath)
        
        (cell as? ChoosePokemonCollectionViewCell)?.bindData(pokemon: pokemonList[indexPath.row])
        
        (cell as? ChoosePokemonCollectionViewCell)?.choosePokemonCellDelegate = self
        
        // Transform the cell size based on the scale
        cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return cell
    }
    
}

extension ChoosePokemonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width * CGFloat(C.POKEMON_CELL_WIDTH_PERCENTAGE), height: collectionView.bounds.size.height * CGFloat(C.POKEMON_CELL_HEIGHT_PERCENTAGE))
    }
}

extension ChoosePokemonViewController : UIScrollViewDelegate {
    // perform scaling whenever the collection view is being scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(!seekSlider.isTouchInside) {

            seekSlider.value = Float(pokemonCollectionView.indexPathsForVisibleItems[0].row)/Float(pokemonList.count - 1)
        }
        
        resizeCells()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pokemonCollectionView.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.pokemonCollectionView.scrollToNearestVisibleCollectionViewCell()
        }
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
            
            // Transform the cell size based on the scale
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }
    }
}
