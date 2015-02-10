import Foundation

protocol ArithmeticType : Comparable {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    init()
    init(Int)
}

extension Double: ArithmeticType {}
extension Int: ArithmeticType {}

public func deltas(values: [NSTimeInterval]) -> [NSTimeInterval] {
    if countElements(values) < 2 {
        return []
    }

    let shiftedValues = Array(values[1..<values.count])
    let zippedValues = Array(Zip2(values, shiftedValues))
    return zippedValues.map { (val1, val2) in val2-val1 }
}

extension Array {
    func min<T: Comparable>() -> T? {
        if (self.count > 0) {
            let typed: [T] = map { $0 as T }
            return typed.reduce(typed[0]) { Swift.min($0, $1) }
        }
        else {
            return nil
        }
    }

    func max<T: Comparable>() -> T? {
        if (self.count > 0) {
            let typed: [T] = map { $0 as T }
            return typed.reduce(typed[0]) { Swift.max($0, $1) }
        }
        else {
            return nil
        }
    }

    func sum<T: ArithmeticType>() -> T? {
        if (self.count > 0) {
            return self.map { $0 as T }.reduce(T()) { $0 + $1 }
        }
        else {
            return nil
        }
    }

    func avg<T: ArithmeticType>() -> T? {
        if (self.count > 0) {
            return sum()! / T(self.count)
        }
        else {
            return nil
        }
    }
}
