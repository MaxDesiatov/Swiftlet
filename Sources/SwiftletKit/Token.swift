//
//  Token.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 17/09/2018.
//

// enum KeywordType: String {
//  case `let`
//  case `var`
//  case `return`
//  case `throw`
//  case `throws`
//  case `enum`
//  case `case`
//  case `struct`
//  case `class`
//  case `protocol`
//  case `func`
//  case `final`
//  case `private`
//  case `public`
//  case `internal`
//  case `static`
//  case `catch`
//  case `repeat`
//  case `while`
//  case `do`
//  case `try`
//  case `where`
//  case `guard`
//  case `if`
//  case `else`
//  case `self`
//  case `nil`
//  case `import`
//  case `set`
//  case `get`
//  case `didSet`
//  case `willSet`
// }
//
// public struct Token {
//  let line: Int
//  let lineLocation: Range<String.Index>
//  let type: TokenType

/// This excludes any delimiters, e.g. # for directives, @ for attributes,
/// quotes for strings etc
//  let value: Substring
// }

// enum BracketType {
//  case curly
//  case paren
//  case angle
//  case square
// }
//
// enum LiteralType {
//  case bool(Bool)
//  case number
//  case string
// }

// enum TokenType {
//  case space
//  case newline
//  case tab
//  case colon
//  case semicolon
//  case backslash
//  case openBracket(BracketType)
//  case closeBracket(BracketType)
//  case keyword(KeywordType)
//  case identifier
//  case literal(LiteralType)
//  case `operator`
//  case closureTypeOperator
//  case placeholder
//  case questionMark
//  case exclamationMark
//  case directive
//  case attribute
//  case doubleQuote
//  case backtick
// }
