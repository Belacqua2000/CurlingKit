//
//  ExportVersion.swift
//
//
//  Created by Nick Baughan on 10/05/2024.
//

import Foundation
import SwiftData

public protocol ExportVersion: Codable {
    associatedtype Model: PersistentModel
    static var version: Int { get }
    static var fileExtension: String { get }
    
    var fileName: String { get }
    
    func modelFromFile(using context: ModelContext) -> Model
    
    init?(from model: Model)
    
    init(fileWrapper: FileWrapper) throws
}

extension ExportVersion {
    public init(url: URL, securityURL: Bool = true) throws {
        guard !securityURL || url.startAccessingSecurityScopedResource() else {
            throw CocoaError(.fileReadNoPermission)
        }
        defer { url.stopAccessingSecurityScopedResource() }
        
        let wrapper = try FileWrapper(url: url)
        self = try Self(fileWrapper: wrapper)
    }
    
    public init(fileWrapper: FileWrapper) throws {
        guard let data = fileWrapper.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public init(data: Data) throws {
        let wrapper = FileWrapper(regularFileWithContents: data)
        self = try Self(fileWrapper: wrapper)
    }
    
    public func url() throws -> URL {
        let tempDirect = FileManager.default.temporaryDirectory
        let url = tempDirect.appendingPathComponent("\(fileName).\(Self.fileExtension)")
        try archiveFileWrapper().write(to: url, originalContentsURL: nil)
        return url
    }
    
    public func data() throws -> Data {
        guard let data = try? archiveFileWrapper().serializedRepresentation else {
            throw ExportError.noData
        }
        return data
    }
    
    func archiveFileWrapper() throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
}

enum ExportError: Error {
    case noData
}
