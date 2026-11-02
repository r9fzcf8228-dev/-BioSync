import Foundation
import SwiftData

@Model
final class Patient {
    var id: UUID
    var name: String
    var condition: String // حالة المريض (خطير، متوسط، مستقر)
    var heartRate: Int
    var bloodType: String
    
    init(name: String, condition: String, heartRate: Int, bloodType: String) {
        self.id = UUID()
        self.name = name
        self.condition = condition
        self.heartRate = heartRate
        self.bloodType = bloodType
    }
}
