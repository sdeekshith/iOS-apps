//
//  Web.swift
//  Firebase_data_app
//
//  Created by IOSLevel-01 on 03/04/19.
//  Copyright © 2019 sjbit. All rights reserved.
//

import Foundation

class Web{
    var country: String!
    var capital: String!
    var region: String!
    var subregion:String!
    var area:String!
    var population:String!
    init( country: String!,capital: String,region: String!,subregion:String!,area:String!,population:String!)
    {
        self.country=country
        self.capital=capital
        self.region=region
        self.subregion=subregion
        self.area=area
        self.population=population
    }
}
