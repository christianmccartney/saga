//
//  AbilityAnimation.swift
//  saga
//
//  Created by Christian McCartney on 11/14/21.
//

import Foundation

typealias AbilityAnimation = ((Entity, Entity?, Position) async -> Void)
let defaultAbilityAnimation: AbilityAnimation = { _,_,_ in }
