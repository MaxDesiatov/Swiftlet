//
//  Result.swift
//  Swiftlet
//
//  Created by Max Desiatov on 17/09/2018.
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