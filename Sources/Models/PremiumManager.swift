import Foundation
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @Published var isPremiumActive: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let productId = "com.ggsheng.StretchGoGo.PremiumMonthly"
    private let premiumKey = "isPremiumActive"
    
    private var updateListenerTask: Task<Void, Error>?
    
    init() {
        loadPremiumStatus()
        startUpdateListener()
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Public Methods
    
    func purchasePremium() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let products = try await Product.products(for: [productId])
            
            guard let product = products.first else {
                errorMessage = "Premium subscription not found"
                isLoading = false
                return false
            }
            
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updatePremiumStatus(true)
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
    
    func restorePurchases() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await AppStore.sync()
            let transactions = try await Transaction.currentEntitlements
            
            for transaction in transactions {
                if case .verified(let safeTransaction) = transaction {
                    if safeTransaction.productID == productId {
                        await updatePremiumStatus(true)
                        isLoading = false
                        return true
                    }
                }
            }
            
            await updatePremiumStatus(false)
            isLoading = false
            return false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func checkPremiumStatus() async {
        do {
            let transactions = try await Transaction.currentEntitlements
            
            var hasActivePremium = false
            for transaction in transactions {
                if case .verified(let safeTransaction) = transaction {
                    if safeTransaction.productID == productId {
                        if safeTransaction.revocationDate == nil {
                            hasActivePremium = true
                            break
                        }
                    }
                }
            }
            
            await updatePremiumStatus(hasActivePremium)
        } catch {
            // Keep current status on error
        }
    }
    
    // MARK: - Private Methods
    
    private func loadPremiumStatus() {
        isPremiumActive = UserDefaults.standard.bool(forKey: premiumKey)
    }
    
    private func updatePremiumStatus(_ isActive: Bool) async {
        isPremiumActive = isActive
        UserDefaults.standard.set(isActive, forKey: premiumKey)
    }
    
    private func startUpdateListener() {
        updateListenerTask = Task.detached { [weak self] in
            for await result in Transaction.updates {
                do {
                    let transaction = try self?.checkVerified(result)
                    
                    if let transaction {
                        await transaction.finish()
                        
                        await MainActor.run {
                            Task {
                                await self?.checkPremiumStatus()
                            }
                        }
                    }
                } catch {
                    // Handle verification error
                }
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Feature Access
    
    var canAccessPremiumFeatures: Bool {
        isPremiumActive
    }
    
    var canAccessAdvancedStats: Bool {
        isPremiumActive
    }
    
    var canAccessVoiceGuidance: Bool {
        isPremiumActive
    }
    
    var canAccessReminders: Bool {
        isPremiumActive
    }
    
    var canAccessAchievements: Bool {
        isPremiumActive
    }
    
    var canAccessAllSessions: Bool {
        isPremiumActive
    }
    
    var canAccessiCloudSync: Bool {
        isPremiumActive
    }
    
    // Locked sessions for free users (first 10 sessions only)
    func isSessionLocked(_ session: StretchSession) -> Bool {
        if isPremiumActive { return false }
        let freeSessionCount = 10
        guard let allSessions = SessionData.allSessions as [StretchSession]? else { return false }
        let sessionIndex = allSessions.firstIndex(where: { $0.id == session.id }) ?? -1
        return sessionIndex >= freeSessionCount
    }
}

// StoreKit Error extension
enum StoreKitError: Error {
    case verificationFailed
    case productNotFound
    case purchaseFailed
}