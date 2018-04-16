import Foundation

extension Double{
    var round: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self))!
    }
    
    var percentFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(from: NSNumber(value: self))!
    }
}
