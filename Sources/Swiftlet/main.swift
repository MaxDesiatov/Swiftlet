//
//  LineReader.swift
//  Swiftlet
//
//  Created by Max Desiatov on 17/09/2018.
//

import SwiftletKit

let testString = "func hello(world: String) -> Int"
let lexer = SplashLexer()
print(lexer.next(testString))

