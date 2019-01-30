//
//  Parser.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 19/09/2018.
//

import SwiftParsec

typealias Parser<T> = GenericParser<String, (), T>

struct Data: Equatable {
  let typename: String
}

indirect enum TypeExpression: Equatable {
  case function(TypeExpression, TypeExpression)
  case tuple([TypeExpression])
  case constructor(String, [String])
}

struct Signature: Equatable {
  let name: String
  let type: TypeExpression
}

enum Pattern: Equatable {}

enum Expression: Equatable {}

enum Declaration: Equatable {
  case signature(Signature)
  case definition(String, [Pattern], Expression)
  case data(Data)
}

let lexer: GenericTokenParser<()> = {
  var result = LanguageDefinition<()>.empty

  result.commentLine = "//"
  result.commentStart = "/*"
  result.commentEnd = "*/"
  result.reservedOperators = ["=", ":", "->", "<-"]
  result.reservedNames = ["protocol", "extension", "data"]

  return GenericTokenParser(languageDefinition: result)
}()

let typeConstructorArguments = lexer.identifier.separatedBy(lexer.whiteSpace)

let typeConstructor = { TypeExpression.constructor($0, $1) } <^>
  (lexer.identifier >>- { id in { (id, $0) } <^> typeConstructorArguments })

let tupleType = TypeExpression.tuple <^>
  lexer.parentheses(typeConstructor.separatedBy(lexer.comma))

// let signature = { (result: (String, String)) in
//  Declaration.signature(Signature(name: result.0, type: result.1))
// } <^> (lexer.identifier <*
//  (lexer.reservedOperator(":") *> lexer.whiteSpace) >>- { id in
//    { (id, $0) } <^> lexer.identifier
// })
//
// let parser = lexer.whiteSpace *> signature
