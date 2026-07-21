import Foundation
import HealthKit

@MainActor
final class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()

    @Published var isAvailable: Bool = HKHealthStore.isHealthDataAvailable()
    @Published var isAuthorized: Bool = false

    private let store = HKHealthStore()

    private init() {}

    /// Request HealthKit authorization for mindful session write
    /// Adds NSHealthShareUsageDescription + NSHealthUpdateUsageDescription to Info.plist required
    /// Adds HealthKit entitlement required
    func requestAuthorization() async {
        guard isAvailable else {
            print("[HealthKit] not available on this device")
            return
        }

        let typesToShare: Set<HKSampleType> = [
            HKCategoryType(.mindfulSession)
        ]
        let typesToRead: Set<HKObjectType> = []

        do {
            try await store.requestAuthorization(toShare: typesToShare, read: typesToRead)
            let writeStatus = store.authorizationStatus(for: HKCategoryType(.mindfulSession))
            isAuthorized = (writeStatus == .sharingAuthorized)
            print("[HealthKit] ✅ authorized (write=\(isAuthorized))")
        } catch {
            print("[HealthKit] ❌ request failed: \(error.localizedDescription)")
            isAuthorized = false
        }
    }

    /// Log a mindful session to HealthKit (called after stretch session completes)
    /// - Parameter duration: session duration in seconds
    func logMindfulSession(duration: TimeInterval) async {
        guard isAvailable, isAuthorized else { return }

        let end = Date()
        let start = end.addingTimeInterval(-duration)
        let sample = HKCategorySample(
            type: HKCategoryType(.mindfulSession),
            value: HKCategoryValue.notApplicable.rawValue,
            start: start,
            end: end
        )

        do {
            try await store.save(sample)
            print("[HealthKit] ✅ logged \(Int(duration/60)) min session")
        } catch {
            print("[HealthKit] ❌ save failed: \(error.localizedDescription)")
        }
    }
}
