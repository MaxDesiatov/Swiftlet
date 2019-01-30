//
//  Expresssion.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 30/01/2019.
//

import func Foundation.pow
import SwiftParsec

func binary(
  _ name: String,
  function: @escaping (Int, Int) -> Int,
  assoc: Associativity
  ) -> Operator<String, (), Int> {
  let opParser = StringParser.string(name) *>
    GenericParser(result: function)
  return .infix(opParser, assoc)
}

func prefix(
  _ name: String,
  function: @escaping (Int) -> Int
  ) -> Operator<String, (), Int> {
  let opParser = StringParser.string(name) *>
    GenericParser(result: function)
  return .prefix(opParser)
}

func postfix(
  _ name: String,
  function: @escaping (Int) -> Int
  ) -> Operator<String, (), Int> {
  let opParser = StringParser.string(name) *>
    GenericParser(result: function)
  return .postfix(opParser.attempt)
}

let power: (Int, Int) -> Int = { base, exp in
  Int(pow(Double(base), Double(exp)))
}

let opTable: OperatorTable<String, (), Int> = [
  [
    prefix("-", function: -),
    prefix("+", function: { $0 }),
    ],
  [
    binary("^", function: power, assoc: .right),
    ],
  [
    binary("*", function: *, assoc: .left),
    binary("/", function: /, assoc: .left),
    ],
  [
    binary("+", function: +, assoc: .left),
    binary("-", function: -, assoc: .left),
    ],
]

let openingParen = StringParser.character("(")
let closingParen = StringParser.character(")")
let decimal = GenericTokenParser<()>.decimal

let intExpression = opTable.makeExpressionParser { expr in
  expr.between(openingParen, closingParen) <|> decimal
}

public func parsec(input: String) throws -> Int {
  return try intExpression.run(sourceName: "", input: input)
}
