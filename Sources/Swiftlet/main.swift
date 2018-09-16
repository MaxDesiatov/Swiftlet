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

//final class Tokenizer: Transformer {
//  private var previousChunk = ""
//
//  func next(_ value: Substring) -> [Result<Token>] {
//
//  }
//}
