import Foundation

struct SessionData {
    static let allSessions: [StretchSession] = [
        // Full Body Sessions
        StretchSession(
            id: UUID(),
            title: "Morning Wake-Up Stretch",
            description: "Energize your morning with this gentle full-body stretch routine",
            duration: 600,
            difficulty: .beginner,
            bodyPart: .fullBody,
            exercises: [
                Exercise(id: UUID(), name: "Neck Rolls", description: "Roll your neck in slow circles", duration: 30, imageName: "neck_roll", repetitions: 5, side: .both),
                Exercise(id: UUID(), name: "Shoulder Shrugs", description: "Lift shoulders to ears and release", duration: 30, imageName: "shoulder_shrug", repetitions: 10, side: .both),
                Exercise(id: UUID(), name: "Standing Side Stretch", description: "Reach one arm overhead and lean to the side", duration: 60, imageName: "side_stretch", repetitions: nil, side: .both),
                Exercise(id: UUID(), name: "Forward Fold", description: "Bend forward from hips, let arms hang", duration: 45, imageName: "forward_fold", repetitions: nil, side: .both),
                Exercise(id: UUID(), name: "Cat-Cow Stretch", description: "On all fours, arch and round your spine", duration: 60, imageName: "cat_cow", repetitions: 10, side: .both),
                Exercise(id: UUID(), name: "Child's Pose", description: "Sit back on heels, stretch arms forward", duration: 45, imageName: "child_pose", repetitions: nil, side: .both)
            ],
            thumbnailName: "morning_wakeup"
        ),
        StretchSession(
            id: UUID(),
            title: "Desk Break Relief",
            description: "Quick stretches perfect for your workday break",
            duration: 300,
            difficulty: .beginner,
            bodyPart: .fullBody,
            exercises: [
                Exercise(id: UUID(), name: "Seated Neck Stretch", description: "Gently tilt head to one side", duration: 30, imageName: "seated_neck", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Seated Neck Stretch", description: "Gently tilt head to the other side", duration: 30, imageName: "seated_neck", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Shoulder Rolls", description: "Roll shoulders in circles", duration: 30, imageName: "shoulder_roll", repetitions: 10, side: .both),
                Exercise(id: UUID(), name: "Seated Spinal Twist", description: "Twist torso to one side while seated", duration: 45, imageName: "spinal_twist", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Seated Spinal Twist", description: "Twist torso to the other side", duration: 45, imageName: "spinal_twist", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Wrist Circles", description: "Rotate wrists in circles", duration: 30, imageName: "wrist_circle", repetitions: 10, side: .both)
            ],
            thumbnailName: "desk_break"
        ),
        StretchSession(
            id: UUID(),
            title: "Evening Wind Down",
            description: "Relax your body before bed with calming stretches",
            duration: 900,
            difficulty: .beginner,
            bodyPart: .fullBody,
            exercises: [
                Exercise(id: UUID(), name: "Deep Breathing", description: "Breathe deeply, inhale for 4 counts, exhale for 6", duration: 60, imageName: "deep_breathing", repetitions: 5, side: .both),
                Exercise(id: UUID(), name: "Neck Range of Motion", description: "Gently move neck in all directions", duration: 45, imageName: "neck_rom", repetitions: nil, side: .both),
                Exercise(id: UUID(), name: "Seated Forward Fold", description: "Reach toward toes from seated position", duration: 60, imageName: "seated_forward", repetitions: nil, side: .both),
                Exercise(id: UUID(), name: "Supine Figure Four", description: "Lie on back, cross ankle over knee", duration: 60, imageName: "figure_four", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Supine Figure Four", description: "Cross other ankle over knee", duration: 60, imageName: "figure_four", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Legs Up The Wall", description: "Lie with legs extended up against wall", duration: 90, imageName: "legs_wall", repetitions: nil, side: .both),
                Exercise(id: UUID(), name: "Corpse Pose", description: "Lie flat, relax completely", duration: 120, imageName: "corpse_pose", repetitions: nil, side: .both)
            ],
            thumbnailName: "evening_winddown"
        ),

        // Upper Body Sessions
        StretchSession(
            id: UUID(),
            title: "Shoulder Mobility",
            description: "Improve shoulder flexibility and range of motion",
            duration: 600,
            difficulty: .intermediate,
            bodyPart: .upperBody,
            exercises: [
                Exercise(id: UUID(), name: "Arm Circles", description: "Extend arms and make large circles", duration: 45, imageName: "arm_circles", repetitions: 10, side: .both),
                Exercise(id: UUID(), name: "Doorway Chest Stretch", description: "Place arm on doorframe, lean forward", duration: 60, imageName: "chest_stretch", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Doorway Chest Stretch", description: "Place other arm on doorframe, lean forward", duration: 60, imageName: "chest_stretch", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Eagle Arms", description: "Wrap one arm under the other, press palms together", duration: 45, imageName: "eagle_arms", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Eagle Arms", description: "Wrap other arm under, press palms together", duration: 45, imageName: "eagle_arms", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Thread The Needle", description: "Rotate arm through imaginary thread", duration: 60, imageName: "thread_needle", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Thread The Needle", description: "Rotate other arm through", duration: 60, imageName: "thread_needle", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Cow Face Arms", description: "Press palms together behind back", duration: 60, imageName: "cow_face", repetitions: nil, side: .both)
            ],
            thumbnailName: "shoulder_mobility"
        ),
        StretchSession(
            id: UUID(),
            title: "Arm & Wrist Relief",
            description: "Perfect for those who type all day",
            duration: 300,
            difficulty: .beginner,
            bodyPart: .upperBody,
            exercises: [
                Exercise(id: UUID(), name: "Prayer Stretch", description: "Press palms together at chest, lower to waist", duration: 45, imageName: "prayer_stretch", repetitions: nil, side: .both),
                Exercise(id: UUID(), name: "Wrist Flexor Stretch", description: "Extend arm, pull fingers back with other hand", duration: 30, imageName: "wrist_flexor", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Wrist Flexor Stretch", description: "Extend other arm, pull fingers back", duration: 30, imageName: "wrist_flexor", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Wrist Extensor Stretch", description: "Make fist, fold fingers under thumb, press", duration: 30, imageName: "wrist_extensor", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Wrist Extensor Stretch", description: "Make fist with other hand, press", duration: 30, imageName: "wrist_extensor", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Finger Spreads", description: "Spread fingers wide, hold, release", duration: 30, imageName: "finger_spread", repetitions: 10, side: .both)
            ],
            thumbnailName: "arm_wrist_relief"
        ),

        // Lower Body Sessions
        StretchSession(
            id: UUID(),
            title: "Leg Day Recovery",
            description: "Essential stretches after intense leg workouts",
            duration: 900,
            difficulty: .intermediate,
            bodyPart: .lowerBody,
            exercises: [
                Exercise(id: UUID(), name: "Standing Quad Stretch", description: "Hold foot behind you, keep knees together", duration: 60, imageName: "quad_stand", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Standing Quad Stretch", description: "Hold other foot behind you", duration: 60, imageName: "quad_stand", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Standing Hamstring Stretch", description: "Place heel on elevated surface, lean forward", duration: 60, imageName: "hamstring_stand", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Standing Hamstring Stretch", description: "Place other heel up, lean forward", duration: 60, imageName: "hamstring_stand", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Piriformis Stretch", description: "Lie on back, cross ankle over knee, pull thigh", duration: 60, imageName: "piriformis", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Piriformis Stretch", description: "Cross other ankle over knee, pull thigh", duration: 60, imageName: "piriformis", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Calf Stretch Against Wall", description: "Lean against wall, press heel down", duration: 45, imageName: "calf_wall", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Calf Stretch Against Wall", description: "Switch to other leg", duration: 45, imageName: "calf_wall", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Butterfly Stretch", description: "Sit with soles of feet together, lean forward", duration: 90, imageName: "butterfly", repetitions: nil, side: .both)
            ],
            thumbnailName: "leg_day_recovery"
        ),
        StretchSession(
            id: UUID(),
            title: "Hip Opening Flow",
            description: "Deep hip stretches for flexibility and pain relief",
            duration: 1200,
            difficulty: .advanced,
            bodyPart: .lowerBody,
            exercises: [
                Exercise(id: UUID(), name: "Hip Circles", description: "Stand on one leg, make circles with the other", duration: 60, imageName: "hip_circles", repetitions: 10, side: .left),
                Exercise(id: UUID(), name: "Hip Circles", description: "Circle with other leg", duration: 60, imageName: "hip_circles", repetitions: 10, side: .right),
                Exercise(id: UUID(), name: "Low Lunge", description: "Deep lunge position, drop back knee", duration: 90, imageName: "low_lunge", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Low Lunge", description: "Switch legs", duration: 90, imageName: "low_lunge", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Pigeon Pose", description: "Bring one leg forward, extend other back", duration: 120, imageName: "pigeon", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Pigeon Pose", description: "Switch legs", duration: 120, imageName: "pigeon", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Frog Stretch", description: "Wide kneeling, push hips back", duration: 120, imageName: "frog", repetitions: nil, side: .both),
                Exercise(id: UUID(), name: "Lizard Pose", description: "Low lunge with hands inside front foot", duration: 90, imageName: "lizard", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Lizard Pose", description: "Switch sides", duration: 90, imageName: "lizard", repetitions: nil, side: .right)
            ],
            thumbnailName: "hip_opening"
        ),

        // Back & Spine Sessions
        StretchSession(
            id: UUID(),
            title: "Spine Relief",
            description: "Decompress and mobilize your spine",
            duration: 600,
            difficulty: .beginner,
            bodyPart: .backSpine,
            exercises: [
                Exercise(id: UUID(), name: "Cat-Cow", description: "Alternate between arching and rounding spine", duration: 90, imageName: "cat_cow", repetitions: 10, side: .both),
                Exercise(id: UUID(), name: "Child's Pose", description: "Sit back on heels, stretch arms forward", duration: 60, imageName: "child_pose", repetitions: nil, side: .both),
                Exercise(id: UUID(), name: "Cat Stretch", description: "Round spine toward ceiling, tuck chin", duration: 45, imageName: "cat_stretch", repetitions: 8, side: .both),
                Exercise(id: UUID(), name: "Cow Stretch", description: "Arch spine, lift chest and tailbone", duration: 45, imageName: "cow_stretch", repetitions: 8, side: .both),
                Exercise(id: UUID(), name: "Seated Spinal Twist", description: "Sit tall, twist torso to side", duration: 60, imageName: "seated_twist", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Seated Spinal Twist", description: "Twist to other side", duration: 60, imageName: "seated_twist", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Knee-to-Chest", description: "Lie on back, pull one knee to chest", duration: 45, imageName: "knee_chest", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Knee-to-Chest", description: "Pull other knee to chest", duration: 45, imageName: "knee_chest", repetitions: nil, side: .right)
            ],
            thumbnailName: "spine_relief"
        ),

        // Neck & Shoulders Sessions
        StretchSession(
            id: UUID(),
            title: "Neck & Shoulder Tension Release",
            description: "Release built-up tension in neck and shoulders",
            duration: 300,
            difficulty: .beginner,
            bodyPart: .neckShoulders,
            exercises: [
                Exercise(id: UUID(), name: "Chin Tucks", description: "Pull chin straight back, creating a double chin", duration: 30, imageName: "chin_tuck", repetitions: 10, side: .both),
                Exercise(id: UUID(), name: "Neck Side Bend", description: "Tilt ear toward shoulder", duration: 45, imageName: "neck_side", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Neck Side Bend", description: "Tilt other ear toward shoulder", duration: 45, imageName: "neck_side", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Neck Rotation", description: "Slowly turn head to look over shoulder", duration: 45, imageName: "neck_rotation", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Neck Rotation", description: "Turn head to other side", duration: 45, imageName: "neck_rotation", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Scalene Stretch", description: "Look diagonally, apply gentle pressure", duration: 45, imageName: "scalene", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Scalene Stretch", description: "Other side diagonally", duration: 45, imageName: "scalene", repetitions: nil, side: .right)
            ],
            thumbnailName: "neck_shoulder_release"
        ),

        // Hip Flexors & IT Band Sessions
        StretchSession(
            id: UUID(),
            title: "IT Band & Hip Flexor Recovery",
            description: "Essential stretches for runners and sitters",
            duration: 600,
            difficulty: .intermediate,
            bodyPart: .hipFlexors,
            exercises: [
                Exercise(id: UUID(), name: "Standing Hip Flexor Stretch", description: "Step back into lunge, drop back knee", duration: 60, imageName: "hip_flexor_stand", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Standing Hip Flexor Stretch", description: "Switch legs", duration: 60, imageName: "hip_flexor_stand", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "IT Band Stretch Standing", description: "Cross one leg behind, lean to opposite side", duration: 60, imageName: "it_band_stand", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "IT Band Stretch Standing", description: "Switch legs", duration: 60, imageName: "it_band_stand", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Half Split", description: "Low lunge with back knee down, hands on front thigh", duration: 90, imageName: "half_split", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Half Split", description: "Switch legs", duration: 90, imageName: "half_split", repetitions: nil, side: .right),
                Exercise(id: UUID(), name: "Reclined Hip Flexor", description: "Lie on back, pull knee to opposite shoulder", duration: 60, imageName: "reclined_hip", repetitions: nil, side: .left),
                Exercise(id: UUID(), name: "Reclined Hip Flexor", description: "Pull other knee across", duration: 60, imageName: "reclined_hip", repetitions: nil, side: .right)
            ],
            thumbnailName: "itband_hipflexor"
        )
    ]
}

struct AchievementData {
    static let allAchievements: [Achievement] = [
        Achievement(id: "first_session", title: "First Step", description: "Complete your first session", iconName: "star.fill", requirement: 1, type: .totalSessions),
        Achievement(id: "7_day_streak", title: "Week Warrior", description: "Maintain a 7-day streak", iconName: "flame.fill", requirement: 7, type: .streak),
        Achievement(id: "30_day_streak", title: "Monthly Master", description: "Maintain a 30-day streak", iconName: "flame.circle.fill", requirement: 30, type: .streak),
        Achievement(id: "100_minutes", title: "Century Club", description: "Stretch for 100 total minutes", iconName: "clock.fill", requirement: 100, type: .totalMinutes),
        Achievement(id: "500_minutes", title: "Hour Hunter", description: "Stretch for 500 total minutes", iconName: "clock.badge.fill", requirement: 500, type: .totalMinutes),
        Achievement(id: "10_sessions", title: "Regular Stretch", description: "Complete 10 sessions", iconName: "10.circle.fill", requirement: 10, type: .totalSessions),
        Achievement(id: "50_sessions", title: "Stretch Enthusiast", description: "Complete 50 sessions", iconName: "star.circle.fill", requirement: 50, type: .totalSessions),
        Achievement(id: "weekend_warrior", title: "Weekend Warrior", description: "Stretch on Saturday and Sunday", iconName: "calendar.badge.checkmark", requirement: 0, type: .weekendWarrior)
    ]
}
