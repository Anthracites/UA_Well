import Foundation

enum TherapyType: String, CaseIterable {
    case LTW
    case Prevention
}

class TherapyProgressTracker {
    static let shared = TherapyProgressTracker()
    
    private func dayKey(for type: TherapyType) -> String {
        switch type {
        case .LTW:
            return "LTWCurrentDay"
        case .Prevention:
            return "PreventionCurrentDay"
        }
    }
    
    private func lastMarkedKey(for type: TherapyType) -> String {
        return "LastMarkedDate_\(type.rawValue)"
    }
    
    func completedDays(for type: TherapyType) -> Int {
        UserDefaults.standard.integer(forKey: dayKey(for: type))
    }
    
    func isMarkedToday(for type: TherapyType) -> Bool {
        if let date = UserDefaults.standard.object(forKey: lastMarkedKey(for: type)) as? Date {
            return Calendar.current.isDateInToday(date)
        }
        return false
    }
    
    func markTodayAsCompleted(for type: TherapyType) {
        guard !isMarkedToday(for: type) else {
            print("⚠️ Canceled for today \(type.rawValue)")
            return
        }
        
        let newCount = completedDays(for: type) + 1
        UserDefaults.standard.set(newCount, forKey: dayKey(for: type))
        UserDefaults.standard.set(Date(), forKey: lastMarkedKey(for: type))
        
        switch type
        {
        case TherapyType.LTW:
            LTWManager.shared.DayCount = newCount
        case TherapyType.Prevention:
            PreventionManager.shared.CurrentDay = newCount
        }
        
        print("✅ Added therapy day \(type.rawValue): \(newCount)")
    }
}

