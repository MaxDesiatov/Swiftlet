//
//  Lexer.swift
//  Swiftlet
//
//  Created by Max Desiatov on 17/09/2018.
//

import Splash

public enum SplashToken {
  case splash(String, Splash.TokenType)
  case plainText(String)
  case whitespace(String)
}

public struct SplashLexer: Transformer {
  let highlighter = SyntaxHighlighter(format: LexerOutputFormat())

  public func next(_ value: String) -> [Result<SplashToken>] {
    return highlighter.highlight(value).map(Result.success)
  }

  public init() {
  }
}

struct LexerOutputFormat {
  struct Builder: OutputBuilder {
    private var tokens = [SplashToken]()

    mutating func addToken(_ token: String, ofType type: TokenType) {
      tokens.append(.splash(token, type))
    }

    mutating func addPlainText(_ text: String) {
      tokens.append(.plainText(text))
    }

    mutating func addWhitespace(_ whitespace: String) {
      tokens.append(.whitespace(whitespace))
    }

    func build() -> [SplashToken] {
      return tokens
    }
  }
}

extension LexerOutputFormat: OutputFormat {
  func makeBuilder() -> Builder {
    return Builder()
  }
}
