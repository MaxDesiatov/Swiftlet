//
//  Stream.swift
//  Swiftlet
//
//  Created by Max Desiatov on 16/09/2018.
//

protocol Consumer {
  associatedtype Input

  func next(_ input: Input)
}

protocol Producer {
  associatedtype Output

  mutating func next() -> [Result<Output>]
}

protocol Transformer {
  associatedtype Input
  associatedtype Output

  func next(_ input: Input) -> [Result<Output>]
}

struct Chain<P, T>: Producer
where P: Producer, T: Transformer, P.Output == T.Input
{
  var producer: P
  let transformer: T
  var isFinished: Bool

  mutating func next() -> [Result<T.Output>] {
    let values = producer.next()
    guard values.count > 0 else {
      isFinished = true
      return []
    }

    let x = values.flatMap { producerOutput -> [Result<T.Output>] in
      guard case .success(let output) = producerOutput else {
        if let lifted: Result<T.Output> = producerOutput.lift() {
          return [lifted]
        }

        return []
      }
      return self.transformer.next(output)
    }

    return x
  }
}

extension Producer {
  func pipe<T>(_ transformer: T) -> Chain<Self, T> {
      return Chain(producer: self, transformer: transformer, isFinished: false)
  }
}
