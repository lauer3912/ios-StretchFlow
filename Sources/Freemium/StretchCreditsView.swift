//
//  StretchCreditsView.swift
//  StretchGoGo
//
//  Free Energy Credits & Daily Streak Bonus View
//

import SwiftUI

struct StretchCreditsView: View {
    @State private var balance: Int = 100
    @State private var hasClaimedToday: Bool = false
    @State private var isClaiming: Bool = false
    @State private var showPaywall: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "bolt.heart.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                            Text("Stretch Energy Credits")
                                .font(.headline)
                            Spacer()
                            Text("\(balance) pts")
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                        }

                        Text("Use energy credits to generate customized mobility flows and audio guidance routines.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Divider()

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Daily Mobility Bonus")
                                    .font(.subheadline.bold())
                                Text("+10 credits for daily check-in")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button {
                                claimBonus()
                            } label: {
                                if isClaiming {
                                    ProgressView()
                                } else {
                                    Text(hasClaimedToday ? "Claimed Today" : "Claim +10")
                                        .font(.subheadline.bold())
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(hasClaimedToday || isClaiming)
                        }
                    }
                    .padding(.vertical, 6)
                } header: {
                    Text("Free Tier Quota")
                } footer: {
                    Text("All basic stretching timers and standard posture guides are completely free offline.")
                }

                Section("Unlimited Pro Pass") {
                    Button {
                        showPaywall = true
                    } label: {
                        HStack {
                            Label("Upgrade to Unlimited Pro", systemImage: "crown.fill")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Energy Credits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PremiumPaywallView()
            }
            .task {
                if let bal = try? await BuyservicesClient.shared.fetchBalance() {
                    balance = bal
                }
            }
        }
    }

    private func claimBonus() {
        guard !hasClaimedToday else { return }
        isClaiming = true
        _Concurrency.Task {
            if let newBal = try? await BuyservicesClient.shared.claimDailyBonus() {
                balance += newBal
            } else {
                balance += 10
            }
            hasClaimedToday = true
            isClaiming = false
        }
    }
}
