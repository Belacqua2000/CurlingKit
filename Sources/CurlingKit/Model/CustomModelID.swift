//
//  CustomModelID.swift
//  CurlingKit
//
//  Created by Nick Baughan on 25/10/2024.
//

import CoreTransferable

public struct CustomModelID: Transferable, Codable {
    public let id: UUID
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .modelID)
    }
}
