//
//  SwiftAST.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 19/09/2018.
//

import Foundation

// Codifies official grammar:
// https://docs.swift.org/swift-book/ReferenceManual/zzSummaryOfTheGrammar.html

enum Statement {
  case declaration(Declaration)
  case expression
  case `defer`
  case `do`
  case loop
  case controlTransfer
}

struct SwiftFile {
}
