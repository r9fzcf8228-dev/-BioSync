import Foundation
import CoreMotion
import Combine
import SwiftUI

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var yaw: Double = 0.0
    @Published var isMoving: Bool = false

    init() {
        startUpdates()
    }
    
    func startUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                guard let data = data, error == nil else { return }
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    self?.pitch = data.attitude.pitch
                    self?.roll = data.attitude.roll
                    self?.yaw = data.attitude.yaw
                    
                    self?.isMoving = abs(data.userAcceleration.x) > 0.1 || abs(data.userAcceleration.y) > 0.1
                }
            }
        }
    }
}
