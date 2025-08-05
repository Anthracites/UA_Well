import Foundation

enum TherapyType: String, CaseIterable {
    case LTW
    case Prevention
}

class TherapyProgressTracker {
    static let shared = TherapyProgressTracker()
    
    private func dayKey(for type: TherapyType) -> String {
        return "CompletedDays_\(type.rawValue)"
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
            print("⚠️ Сегодня уже отмечено для \(type.rawValue)")
            return
        }
        
        let newCount = completedDays(for: type) + 1
        UserDefaults.standard.set(newCount, forKey: dayKey(for: type))
        UserDefaults.standard.set(Date(), forKey: lastMarkedKey(for: type))
        
        print("✅ День терапии (\(type.rawValue)) засчитан. Всего: \(newCount)")
    }
}

