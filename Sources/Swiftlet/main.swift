//
//  LineReader.swift
//  Swiftlet
//
//  Created by Max Desiatov on 17/09/2018.
//

import SwiftletKit

let reader = LineReader(path: "Sources/Swiftlet/Result.swift")!

var pipeline = reader.pipe(Lexer())

print(pipeline.next())
