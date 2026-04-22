import Foundation

struct StretchSession: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let duration: Int // in seconds
    let difficulty: Difficulty
    let bodyPart: BodyPart
    let exercises: [Exercise]
    let thumbnailName: String

    var durationMinutes: Int {
        duration / 60
    }

    enum Difficulty: String, Codable, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"

        var color: String {
            switch self {
            case .beginner: return "green"
            case .intermediate: return "orange"
            case .advanced: return "red"
            }
        }
    }

    enum BodyPart: String, Codable, CaseIterable {
        case fullBody = "Full Body"
        case upperBody = "Upper Body"
        case lowerBody = "Lower Body"
        case backSpine = "Back & Spine"
        case neckShoulders = "Neck & Shoulders"
        case hipFlexors = "Hip Flexors & IT Band"

        var icon: String {
            switch self {
            case .fullBody: return "figure.stand"
            case .upperBody: return "figure.arms.open"
            case .lowerBody: return "figure.walk"
            case .backSpine: return "figure.core.training"
            case .neckShoulders: return "figure.flexibility"
            case .hipFlexors: return "figure.step.training"
            }
        }
    }
}

struct Exercise: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let duration: Int // in seconds
    let imageName: String
    let repetitions: Int?
    let side: Side?

    enum Side: String, Codable {
        case left = "Left"
        case right = "Right"
        case both = "Both"
    }
}
