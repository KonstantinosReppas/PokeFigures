//
//  PokemonDetailsModel.swift
//  PokeFigures
//
//  Created by Konstantinos Reppas on 27/4/20.
//  Copyright © 2020 Konstantinos Reppas. All rights reserved.
//

import Foundation

struct PokemonDetailsModel: Codable {
    let types: [TypesArray]
    let stats: [StatsArray]
}

struct TypesArray: Codable {
    let type: TypeOrStat
}
struct StatsArray: Codable {
    let base_stat: Int
    let stat: TypeOrStat
}


struct TypeOrStat: Codable {
    let name: String
    let url: String
}

