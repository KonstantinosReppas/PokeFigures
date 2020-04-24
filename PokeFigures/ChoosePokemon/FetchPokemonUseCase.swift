//
//  FetchPokemonUseCase.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 21/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import Foundation

class FetchPokemonUseCase {
    
    let numOfPokemonPerGen = [151, 100, 135, 107, 156, 72, 86]
    
    var currentGen = 0
    
    func fetchPokemonAndNotify(generation: Int = 0, resultsCallback: @escaping(_ pokemonList: [PokemonModel]) -> Void) {
        currentGen = generation
        if let url = URL(string: constructUrl()) {
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
    
    func constructUrl() -> String {
        var url = "https://pokeapi.co/api/v2/pokemon?offset="
        
        url = url + String(calculateOffset()) + "&limit=" + String(numOfPokemonPerGen[currentGen])
        
        return url
    }

    func calculateOffset() -> Int {
        var offset = 0
        for i in 0..<currentGen {
            offset += numOfPokemonPerGen[i]
        }
        return offset
    }
    
    func parseJSON(_ pokemonData: Data) -> [PokemonModel]? {
        var pokemonList = [PokemonModel]()
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PokemonResults.self, from: pokemonData)
            for i in 0..<decodedData.results.count {
                var pokemon = decodedData.results[i]
                pokemon.imageUrl = "https://pokeres.bastionbot.org/images/pokemon/\(calculateOffset() + i + 1).png"
                pokemon.number = i + 1
                pokemon.name.capitalizeFirstLetter()
                pokemonList.append(pokemon)
            }
            
            return pokemonList
            
        } catch {
            return nil
        }
    }
        
}
