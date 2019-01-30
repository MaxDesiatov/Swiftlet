//
//  FileReader.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 18/09/2018.
//

import Foundation

public final class FileReader: Producer {
  public typealias Output = String

  private let path: String
  private let handle: FileHandle

  public init?(path: String) {
    guard let handle = FileHandle(forReadingAtPath: path) else {
      return nil
    }

    self.path = path
    self.handle = handle
  }

  public func next() -> [Result<String>] {
    let d = handle.readDataToEndOfFile()

    guard !d.isEmpty else { return [] }

    guard let s = String(data: d, encoding: .utf8) else {
      return [.failure(
        SError.lineReaderError("Can't read file \(path) in UTF-8")
      )]
    }

    return [.success(s)]
  }
}
