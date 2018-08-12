//
//  PKSessionCharacteristics.swift
//  CUU
//
//  Created by Florian Fittschen on 04.08.18.
//

import Foundation

class PKSessionCharacteristics: CUUCharacteristics {

    // MARK: - Properties

    let sessionId: String
    let start: Date
    let end: Date
    let durationInSeconds: Double
    let mostVisitedScene: String?
    let averageTimeOnScene: Double?

    // MARK: - Lifecycle

    init(session: PKSession) {
        guard let end = session.end else {
            preconditionFailure("Cannot create PKSessionCharacteristics from a session without an end.")
        }

        self.sessionId = session.sessionId
        self.start = session.start
        self.end = end
        self.durationInSeconds = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
        self.mostVisitedScene = session.mostVisitedScene
        self.averageTimeOnScene = session.averageTimeOnScene

        super.init()
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    // MARK: - Serialization

    private enum CodingKeys: String, CodingKey {
        case sessionId
        case start
        case end
        case durationInSeconds
        case mostVisitedScene
        case averageTimeOnScene
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(start, forKey: .start)
        try container.encode(end, forKey: .end)
        try container.encode(durationInSeconds, forKey: .durationInSeconds)
        try container.encodeIfPresent(mostVisitedScene, forKey: .mostVisitedScene)
        try container.encodeIfPresent(averageTimeOnScene, forKey: .averageTimeOnScene)

        try super.encode(to: encoder)
    }
}