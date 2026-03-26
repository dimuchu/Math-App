import Foundation
import SwiftData

extension ModelContainer {
    static let shared: ModelContainer = {
        let schema = Schema(versionedSchema: SchemaV1.self)
        let configuration = ModelConfiguration(
            "MentalMath",
            schema: schema
        )
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            #if DEBUG
            let nsError = error as NSError
            print("[SwiftData] Failed to create ModelContainer")
            print("[SwiftData] Error: \(error)")
            print("[SwiftData] Domain: \(nsError.domain), Code: \(nsError.code)")
            print("[SwiftData] UserInfo: \(nsError.userInfo)")
            #endif
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}

enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [
            Session.self,
            UserProfile.self,
            SkillLevel.self,
        ]
    }
}
