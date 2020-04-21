//
//  PokemonModel.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 21/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import Foundation

struct PokemonResults: Codable {
    let results: [PokemonModel]
}

struct PokemonModel: Codable {
    
    var name: String
    var imageUrl: String?
}
