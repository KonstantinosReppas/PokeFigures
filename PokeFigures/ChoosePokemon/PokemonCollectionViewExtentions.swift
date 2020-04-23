//
//  PokemonCollectionViewExtentions.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 23/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import Foundation
import UIKit

extension ChoosePokemonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoosePokemonCollectionViewCell", for: indexPath)
        
        (cell as? ChoosePokemonCollectionViewCell)?.bindData(pokemon: pokemonList[indexPath.row])
        
//        (cell as? ChoosePokemonCollectionViewCell)?.choosePokemonCellDelegate = self
        
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
    
    fileprivate func resizeCellsProcedure(_ cell: UICollectionViewCell, _ centerX: CGFloat) {
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
    
    @objc func resizeCells() {
        // center X of collection View
        let centerX = self.pokemonCollectionView.center.x
        
        // only perform the scaling on cells that are visible on screen
        for cell in self.pokemonCollectionView.visibleCells {
            
            resizeCellsProcedure(cell, centerX)
        }
    }
}
