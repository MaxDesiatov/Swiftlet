//
//  Tokenizer.swift
//  Swiftlet
//
//  Created by Max Desiatov on 17/09/2018.
//

enum KeywordType {
  case `let`
  case `return`
  case `var`
}

struct Token {
  let line: Int
  let lineLocation: Range<String.Index>
  let value: Substring
  let type: TokenType
}

enum Bracket {
  case open
  case close
}

enum TokenType {
  case space
  case newline
  case tab
  case colon
  case semicolon
  case curly(Bracket)
  case paren(Bracket)
  case angle(Bracket)
  case square(Bracket)
  case keyword(KeywordType)
  case identifier
}

final class Tokenizer: Transformer {
  func next(_ value: Substring) -> [Result<Token>] {
    return []
  }
}
