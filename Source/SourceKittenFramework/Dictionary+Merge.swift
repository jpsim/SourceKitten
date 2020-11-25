/**
Returns a new dictionary by adding the entries of dict2 into dict1, overriding if the key exists.

- parameter dict1: Dictionary to merge into.
- parameter dict2: Dictionary to merge from (optional).

- returns: A new dictionary by adding the entries of dict2 into dict1, overriding if the key exists.
*/
internal func merge<K, V>(_ dict1: [K: V], _ dict2: [K: V]?) -> [K: V] {
    var mergedDict = dict1
    if let dict2 = dict2 {
        for (key, value) in dict2 {
            mergedDict[key] = value
        }
    }
    return mergedDict
}
