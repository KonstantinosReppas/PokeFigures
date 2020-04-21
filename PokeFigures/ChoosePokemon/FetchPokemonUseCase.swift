//
//  FetchPokemonUseCase.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 21/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import Foundation

class FetchPokemonUseCase {
    
    let url = "https://pokeapi.co/api/v2/pokemon?limit=151"
    
    func fetchPokemonAndNotify(resultsCallback: @escaping(_ pokemonList: [PokemonModel]) -> Void) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                if error != nil {
                    resultsCallback([])
                    return
                }
                if let safeData = data {
                    if let pokemonList = self.parseJSON(safeData) {
                       resultsCallback(pokemonList)
                    }
                    else{
                        resultsCallback([])
                    }
                    
                }
                
            })
            task.resume()
            
        }
    }
    

    
    func parseJSON(_ pokemonData: Data) -> [PokemonModel]? {
        var pokemonList = [PokemonModel]()
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PokemonResults.self, from: pokemonData)
            for i in 0..<decodedData.results.count {
                var pokemon = decodedData.results[i]
                pokemon.imageUrl = "https://pokeres.bastionbot.org/images/pokemon/\(i + 1).png"
                pokemon.name.capitalizeFirstLetter()
                pokemonList.append(pokemon)
            }
            
            return pokemonList
            
        } catch {
            return nil
        }
    }
        
}
