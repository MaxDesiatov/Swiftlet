//
//  Stream.swift
//  Swiftlet
//
//  Created by Max Desiatov on 16/09/2018.
//

enum Result<T> {
    case success(T)
    case failure(Error)

    func lift<T2>() -> Result<T2>? {
        guard case .failure(let error) = self else {
            return nil
        }

        return .failure(error)
    }
}

protocol Consumer {
    associatedtype Input

    func next(_ input: Input)
}

protocol Producer {
    associatedtype Output

    mutating func next() -> Result<Output>?
}

protocol Transformer {
    associatedtype Input
    associatedtype Output

    func next(_ input: Input) -> Result<Output>?
}


struct Chain<P, T>: Producer
    where P: Producer, T: Transformer, P.Output == T.Input
{
    var producer: P
    let transformer: T
    var isFinished: Bool

    mutating func next() -> Result<T.Output>? {
        guard let value = producer.next() else {
            isFinished = true
            return nil
        }

        guard case .success(let output) = value else {
            return value.lift()
        }

        return transformer.next(output)
    }
}

extension Producer {
    func pipe<T>(_ transformer: T) -> Chain<Self, T> {
        return Chain(producer: self, transformer: transformer, isFinished: false)
    }
}
