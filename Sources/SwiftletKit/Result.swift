//
//  Result.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 17/09/2018.
//

public enum Result<T> {
  case success(T)
  case failure(Error)

  var success: T? {
    guard case .success(let s) = self else {
      return nil
    }

    return s
  }

  var failure: Error? {
    guard case .failure(let e) = self else {
      return nil
    }

    return e
  }

  func lift<T2>() -> Result<T2>? {
    guard case .failure(let error) = self else {
      return nil
    }

    return .failure(error)
  }
}
