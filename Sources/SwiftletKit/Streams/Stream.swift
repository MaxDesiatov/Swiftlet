//
//  Stream.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 16/09/2018.
//

protocol Consumer {
  associatedtype Input

  func next(_ input: Input)
}

public protocol Producer {
  associatedtype Output

  mutating func next() -> [Result<Output>]
}

public protocol Transformer {
  associatedtype Input
  associatedtype Output

  func next(_ input: Input) -> [Result<Output>]
}

public final class Chain<P, T>: Producer
  where P: Producer, T: Transformer, P.Output == T.Input {
  private var producer: P
  private let transformer: T
  private(set) var isFinished: Bool

  public func next() -> [Result<T.Output>] {
    let values = producer.next()
    guard values.count > 0 else {
      isFinished = true
      return []
    }

    return values.flatMap { producerOutput -> [Result<T.Output>] in
      guard case let .success(output) = producerOutput else {
        if let lifted: Result<T.Output> = producerOutput.lift() {
          return [lifted]
        }

        return []
      }
      return self.transformer.next(output)
    }
  }

  init(producer: P, transformer: T) {
    self.producer = producer
    self.transformer = transformer
    isFinished = false
  }
}

public extension Producer {
  func pipe<T>(_ transformer: T) -> Chain<Self, T> {
    return Chain(producer: self, transformer: transformer)
  }
}
