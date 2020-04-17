//
//  FloatExtension.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/17/20.
//  Copyright © 2020 TBC. All rights reserved.
//

enum Direction: String {

    case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw

}

extension Direction: CustomStringConvertible {

    static let all: [Direction] = [.n, .nne, .ne, .ene, .e, .ese, .se, .sse, .s, .ssw, .sw, .wsw, .w, .wnw, .nw, .nnw]

    init(_ direction: Float) {
        let index = Int((direction + 11.25).truncatingRemainder(dividingBy: 360) / 22.5)
        self = Direction.all[index]
    }

    var description: String {
        return rawValue.uppercased()
    }

}

extension Float {

    var direction: Direction {
        return Direction(self)
    }

}
