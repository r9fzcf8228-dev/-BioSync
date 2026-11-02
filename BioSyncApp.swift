import SwiftUI
import SwiftData

@main
struct BioSyncApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
        .modelContainer(for: [Patient.self])
    }
}

struct MainAppView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                MainTabView().transition(.opacity)
            } else {
                // شاشة البداية
                ZStack {
                    Color.black.ignoresSafeArea()
                    VStack(spacing: 20) {
                        Image(systemName: "waveform.path.ecg.rectangle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 20)
                        
                        Text("BIOSYNC")
                            .font(.system(size: 40, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                            .tracking(10)
                        
                        Text("TACTICAL MEDICAL SYSTEM")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.green)
                            .tracking(5)
                    }
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 1.0)) { self.isActive = true }
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HUDView()
                .tabItem { Label("HUD", systemImage: "waveform.path.ecg") }
            
            TriageView()
                .tabItem { Label("Triage", systemImage: "cross.case.fill") }
        }
        .tint(.green)
    }
}
