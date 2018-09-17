//
//  Lexer.swift
//  Swiftlet
//
//  Created by Max Desiatov on 17/09/2018.
//

import Splash

public struct Lexer: Transformer {
  let highlighter = SyntaxHighlighter(format: LexerOutputFormat())

  public func next(_ value: String) -> [Result<TokenType>] {
    return highlighter.highlight(value).map(Result.success)
  }

  public init() {
  }
}

struct LexerOutputFormat {
  struct Builder: OutputBuilder {
    private var components = [TokenType]()

    mutating func addToken(_ token: String, ofType type: TokenType) {
      components.append(type)
    }

    mutating func addPlainText(_ text: String) {
    }

    mutating func addWhitespace(_ whitespace: String) {
      // Ignore whitespace
    }

    func build() -> [TokenType] {
      return components
    }
  }
}

extension LexerOutputFormat: OutputFormat {
  func makeBuilder() -> Builder {
    return Builder()
  }
}
