import Foundation
import StoreKit

@MainActor
final class PremiumManager: ObservableObject {
    static let shared = PremiumManager()

    @Published var isPremiumActive: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var availableProducts: [Product] = []

    // Per 07-02 14:13 佛老爷 拍板
    // Monthly: $0.99 -> $4.99 (5x 涨价, 跟 ReverseWorldGo 对齐)
    // Yearly: $49.99 (new, 跟 ReverseWorldGo 对齐)
    static let monthlyProductId = "com.ggsheng.StretchGoGo.PremiumMonthly"
    static let yearlyProductId = "com.ggsheng.StretchGoGo.PremiumYearly"
    private let premiumKey = "isPremiumActive"

    private var updateListenerTask: Task<Void, Error>?

    init() {
        loadPremiumStatus()
        startUpdateListener()
        Task { await loadProducts() }
    }

    // MARK: - Public Methods

    func loadProducts() async {
        do {
            let products = try await Product.products(for: [
                Self.monthlyProductId,
                Self.yearlyProductId
            ])
            // Yearly first (per A1 UI), then Monthly
            self.availableProducts = products.sorted { lhs, rhs in
                if lhs.id == Self.yearlyProductId { return true }
                if rhs.id == Self.yearlyProductId { return false }
                return lhs.price < rhs.price
            }
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }
    }

    // Buy a specific product (used by paywall to support both Monthly + Yearly)
    func purchasePremium(_ product: Product) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                updatePremiumStatus(true)
                await transaction.finish()
                isLoading = false
                return true

            case .userCancelled:
                isLoading = false
                return false

            case .pending:
                isLoading = false
                return false

            @unknown default:
                isLoading = false
                return false
            }
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // Backward-compat default: purchase Monthly (kept for any legacy callers)
    func purchaseMonthly() async -> Bool {
        guard let product = availableProducts.first(where: { $0.id == Self.monthlyProductId }) else {
            errorMessage = "Monthly product not loaded"
            return false
        }
        return await purchasePremium(product)
    }

    func restorePurchases() async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            try await AppStore.sync()

            for await transaction in Transaction.currentEntitlements {
                if case .verified(let safeTransaction) = transaction {
                    if safeTransaction.productID == Self.monthlyProductId ||
                       safeTransaction.productID == Self.yearlyProductId {
                        updatePremiumStatus(true)
                        isLoading = false
                        return true
                    }
                }
            }

            updatePremiumStatus(false)
            isLoading = false
            return false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    func checkPremiumStatus() async {
        var hasActivePremium = false
        for await transaction in Transaction.currentEntitlements {
            if case .verified(let safeTransaction) = transaction {
                if safeTransaction.productID == Self.monthlyProductId ||
                   safeTransaction.productID == Self.yearlyProductId {
                    if safeTransaction.revocationDate == nil {
                        hasActivePremium = true
                        break
                    }
                }
            }
        }
        updatePremiumStatus(hasActivePremium)
    }

    // MARK: - Private Methods

    private func loadPremiumStatus() {
        isPremiumActive = UserDefaults.standard.bool(forKey: premiumKey)
    }

    private func updatePremiumStatus(_ isActive: Bool) {
        isPremiumActive = isActive
        UserDefaults.standard.set(isActive, forKey: premiumKey)
    }

    private func startUpdateListener() {
        updateListenerTask = Task { [weak self] in
            for await result in Transaction.updates {
                do {
                    guard let transaction = try self?.checkVerified(result) else { continue }
                    await transaction.finish()
                    await self?.checkPremiumStatus()
                } catch {
                    // Handle verification error silently
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw PremiumStoreError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Feature Access

    var canAccessPremiumFeatures: Bool { isPremiumActive }
    var canAccessAdvancedStats: Bool { isPremiumActive }
    var canAccessVoiceGuidance: Bool { isPremiumActive }
    var canAccessReminders: Bool { isPremiumActive }
    var canAccessAchievements: Bool { isPremiumActive }
    var canAccessAllSessions: Bool { isPremiumActive }
    var canAccessiCloudSync: Bool { isPremiumActive }

    // MARK: - Session Lock Check

    func isSessionLocked(_ session: StretchSession) -> Bool {
        guard !isPremiumActive else { return false }
        let freeSessionCount = 10
        guard let index = SessionData.allSessions.firstIndex(where: { $0.id == session.id }) else {
            return false
        }
        return index >= freeSessionCount
    }
}

// StoreKit Error enum
enum PremiumStoreError: Error {
    case verificationFailed
    case productNotFound
    case purchaseFailed
}
