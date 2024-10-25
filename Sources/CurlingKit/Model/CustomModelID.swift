//
//  CustomModelID.swift
//  CurlingKit
//
//  Created by Nick Baughan on 25/10/2024.
//

import CoreTransferable
import UniformTypeIdentifiers

public class CustomModelID: NSObject, Transferable, Codable, NSItemProviderReading, NSItemProviderWriting {
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, (any Error)?) -> Void) -> Progress? {
        do {
            let data = try JSONEncoder().encode(self)
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        return nil
    }
    
    public static let readableTypeIdentifiersForItemProvider: [String] = [UTType.modelID.identifier]
    public static let writableTypeIdentifiersForItemProvider: [String] = [UTType.modelID.identifier]
    
    
    public let id: UUID
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .modelID)
    }
    
    public required init(id: UUID) {
        self.id = id
    }
}
