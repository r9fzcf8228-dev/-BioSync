import SwiftUI

struct HUDView: View {
    @StateObject private var motion = MotionManager()
    @State private var radarAngle: Double = 0
    
    var body: some View {
        ZStack {
            // الخلفية السوداء المطلقة
            Color.black.ignoresSafeArea()
            
            // شبكة الرادار الخلفية
            RadarGrid()
                .stroke(Color.green.opacity(0.15), lineWidth: 1)
                .frame(width: 300, height: 300)
            
            // خط الرادار الدوار
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(
                    AngularGradient(colors: [.green.opacity(0), .green], center: .center),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 300, height: 300)
                .rotationEffect(.degrees(radarAngle))
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        radarAngle = 360
                    }
                }
            
            // البيانات الحية (تتأثر بحركة الهاتف)
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "waveform.path.ecg")
                        .foregroundColor(.green)
                        .font(.title)
                    Text("BIOSYNC ACTIVE")
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.green)
                }
                
                Divider().background(Color.green.opacity(0.5))
                
                VStack(alignment: .leading, spacing: 10) {
                    DataRow(label: "PITCH", value: String(format: "%.2f", motion.pitch), color: .cyan)
                    DataRow(label: "ROLL", value: String(format: "%.2f", motion.roll), color: .cyan)
                    DataRow(label: "YAW", value: String(format: "%.2f", motion.yaw), color: .cyan)
                }
                
                Spacer()
                
                // مؤشر الحالة
                HStack {
                    Circle()
                        .fill(motion.isMoving ? Color.red : Color.green)
                        .frame(width: 10, height: 10)
                        .shadow(color: motion.isMoving ? .red : .green, radius: 5)
                    
                    Text(motion.isMoving ? "MOVEMENT DETECTED" : "STABLE")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(motion.isMoving ? .red : .green)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(motion.isMoving ? Color.red : Color.green, lineWidth: 1))
                
            }
            .padding(30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

// شكل شبكة الرادار
struct RadarGrid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // الدوائر
        for i in 1...3 {
            path.addEllipse(in: CGRect(x: center.x - radius * CGFloat(i)/3, y: center.y - radius * CGFloat(i)/3, width: radius * 2 * CGFloat(i)/3, height: radius * 2 * CGFloat(i)/3))
        }
        
        // الخطوط المتقاطعة
        path.move(to: CGPoint(x: center.x, y: center.y - radius))
        path.addLine(to: CGPoint(x: center.x, y: center.y + radius))
        path.move(to: CGPoint(x: center.x - radius, y: center.y))
        path.addLine(to: CGPoint(x: center.x + radius, y: center.y))
        
        return path
    }
}

struct DataRow: View {
    var label: String
    var value: String
    var color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(color.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(color)
                .shadow(color: color, radius: 3)
        }
    }
}
