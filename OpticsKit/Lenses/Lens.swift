//
//  Lens.swift
//  OpticsKit
//
//  Created by Szymon Mrozek on 07.03.2018.
//  Copyright © 2018 SzymonMrozek. All rights reserved.
//

import Foundation

infix operator *~: MultiplicationPrecedence
infix operator |>: AdditionPrecedence

public struct Lens<Whole, Part> {
    public let view: (Whole) -> Part
    public let set: (Part, Whole) -> Whole
}

public func * <A, B, C> (lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return Lens<A, C>(
        view: { a in rhs.view(lhs.view(a)) },
        set: { (c, a) in lhs.set(rhs.set(c, lhs.view(a)), a) }
    )
}

public func *~ <A, B> (lhs: Lens<A, B>, rhs: B) -> (A) -> A {
    return { a in lhs.set(rhs, a) }
}

public func |> <A, B> (x: A, f: (A) -> B) -> B {
    return f(x)
}

public func |> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}
