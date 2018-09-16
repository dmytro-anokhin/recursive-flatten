//
//  RecursiveFlattenReference.swift
//  RecursiveFlatten
//
//  Created by Dmytro Anokhin on 15/09/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

/// A collection that presents recursively concatenated elements of its base collection and sub-collections
public struct RecursiveFlattenSequence_Reference<Base: Collection> {

    @usableFromInline
    internal let _base: Base

    /// Creates an instance that presents recursively concatenated elements of `base`
    ///
    /// - Complexity: O(1)
    @inlinable
    internal init(_base: Base) {
        self._base = _base
    }
}


extension RecursiveFlattenSequence_Reference : Sequence {

    public typealias Element = Base.Element

    public final class Iterator {

        /// `Iterator` of the outer collection (the collection in which `_base` is an element)
        @usableFromInline
        internal weak var _outer: Iterator?

        /// `Iterator` of the inner collection (the collection that is an element of `_base`)
        @usableFromInline
        internal var _inner: Iterator?

        @usableFromInline
        internal let _base: Base

        @usableFromInline
        internal var _position: Base.Index

        @usableFromInline
        internal init(_outer: Iterator? = nil, _base: Base) {
            self._outer = _outer
            self._inner = nil
            self._base = _base
            self._position = _base.startIndex
        }
    }

    /// Returns an iterator over the elements of this sequence.
    ///
    /// - Complexity: O(1).
    @inlinable
    @inline(__always)
    public func makeIterator() -> Iterator {
        return Iterator(_base: _base)
    }
}


extension RecursiveFlattenSequence_Reference.Iterator : IteratorProtocol {

    public typealias Element = Base.Element

    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists.
    ///
    /// Once `nil` has been returned, all subsequent calls return `nil`.
    @inlinable
    @inline(__always)
    public func next() -> Element? {

        var current = self

        // Find tail-most inner iterator
        while current._inner != nil {
            current = current._inner!
        }

        // Traverse array and nested arrays to find a first non-array element
        repeat {
            // Check if position is not out of bounds
            guard current._position < current._base.endIndex else {
                if current._outer == nil { // Check if there is a step back
                    return nil
                }

                // Step back
                current = current._outer!
                continue
            }

            // Take element and increment the position
            let element = current._base[current._position]
            current._base.formIndex(after: &current._position)

            // If element is the base type create inner iterator and continue traversal
            if let base = element as? Base {
                let iterator = RecursiveFlattenSequence_Reference.Iterator(_outer: current, _base: base)
                current._inner = iterator
                current = iterator
                continue
            }

            return element
        } while true
    }
}


extension Array {

    @inlinable
    public func recursiveFlatten_Reference() -> RecursiveFlattenSequence_Reference<Array<Any>> {
        return RecursiveFlattenSequence_Reference(_base: self)
    }
}
