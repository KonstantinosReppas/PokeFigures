//
//  FetchPokemonDetailsUseCase.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 27/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import Foundation


class FetchPokemonDetailsUseCase {
    
    func fetchPokemonDetailsAndNotify(id: Int, resultsCallback: @escaping (PokemonDetailsModel) -> Void) {
        
        if let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                if error != nil {
                    return
                }
                if let safeData = data {
                    if let details = self.parseJSON(safeData) {
                       resultsCallback(details)
                    }
                }
            })
            task.resume()
        }
    }
    
    func parseJSON(_ pokemonData: Data) -> PokemonDetailsModel? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(PokemonDetailsModel.self, from: pokemonData)
        } catch {
            print(error)
            return nil
        }
    }
}
