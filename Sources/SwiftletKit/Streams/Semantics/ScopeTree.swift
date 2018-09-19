//
//  ScopeTree.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 19/09/2018.
//

import Foundation

enum InheritableType {
  case `protocol`
  case `class`(name: String, generics: [String])
}

struct ClassScope {
  let name: String
  let genericParameters: [String]
  let inheritedTypes: [InheritableType]
}

indirect enum Type {
  case closure(argument: Type, returns: Type, throws: Bool)
  case tuple([Type])
  case instanceType(name: String, generics: [String])
}

struct ProtocolFunction {
  let name: String
  let genericParameters: [String]
  let parameters: [String: Type]
  let returnType: Type?
}

final class ProtocolScope {
  weak var parent: FileScope!

  let associatedTypes = [String]()
  let functions = [ProtocolFunction]()

  init(parent: FileScope) {
    self.parent = parent
  }
}

final class FileScope {
  weak var parent: ModuleScope!

  let imports = [String]()
  let protocols = [String: ProtocolScope]()
  let classes = [String: ClassScope]()

  init(parent: ModuleScope) {
    self.parent = parent
  }
}

final class ModuleScope {
  let files = [String: FileScope]()
}

enum DeclarationType {
  case `class`
  case `struct`
  case `protocol`
  case `extension`
  case `enum`
  case constant
  case variable
  case `import`
  case `typealias`
  case `associatedtype`
  case function
}

struct Declaration {
  let type: DeclarationType
  let body: [Statement]
}

