import SwiftUI
import SwiftData

struct TriageView: View {
    @Environment(\.modelContext) private var context
    @Query private var patients: [Patient]
    @State private var showingAdd = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.02, green: 0.02, blue: 0.05).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(patients) { patient in
                            TriageCard(patient: patient)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("TRIAGE DASHBOARD")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus.circle.fill").foregroundColor(.cyan).font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddPatientView()
            }
        }
    }
}

struct TriageCard: View {
    var patient: Patient
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(patient.name)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "heart.fill").foregroundColor(.red)
                    Text("\(patient.heartRate) BPM").font(.system(.subheadline, design: .monospaced)).foregroundColor(.gray)
                    Text("|").foregroundColor(.gray)
                    Image(systemName: "drop.fill").foregroundColor(.red)
                    Text(patient.bloodType).font(.system(.subheadline, design: .monospaced)).foregroundColor(.gray)
                }
            }
            Spacer()
            
            // حالة المريض
            Text(patient.condition)
                .font(.system(size: 12, weight: .black))
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(conditionColor(patient.condition).opacity(0.2))
                .foregroundColor(conditionColor(patient.condition))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(conditionColor(patient.condition), lineWidth: 1))
                .shadow(color: conditionColor(patient.condition).opacity(0.5), radius: 5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .background(.ultraThinMaterial)
        )
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
    
    func conditionColor(_ condition: String) -> Color {
        if condition == "حرج" { return .red }
        if condition == "متوسط" { return .yellow }
        return .green
    }
}

struct AddPatientView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var condition = "مستقر"
    @State private var hr = "80"
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("اسم المصاب", text: $name)
                Picker("الحالة", selection: $condition) {
                    Text("حرج").tag("حرج")
                    Text("متوسط").tag("متوسط")
                    Text("مستقر").tag("مستقر")
                }
                TextField("نبضات القلب", text: $hr).keyboardType(.numberPad)
            }
            .navigationTitle("إضافة إصابة")
            .toolbar {
                Button("حفظ") {
                    let patient = Patient(name: name, condition: condition, heartRate: Int(hr) ?? 80, bloodType: "O+")
                    context.insert(patient)
                    dismiss()
                }.disabled(name.isEmpty)
                Button("إلغاء") { dismiss() }
            }
        }
    }
}
