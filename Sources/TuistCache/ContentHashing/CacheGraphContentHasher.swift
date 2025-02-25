import Foundation
import TSCBasic
import TuistCore
import TuistGraph
import TuistSupport

public protocol CacheGraphContentHashing {
    /// Hashes graph
    /// - Parameters:
    ///     - graph: Graph to hash
    ///     - cacheProfile: Cache profile currently being used
    ///     - cacheOutputType: Output type of cache -> makes a different hash for a different output type
    func contentHashes(
        for graph: TuistCore.Graph,
        cacheProfile: TuistGraph.Cache.Profile,
        cacheOutputType: CacheOutputType
    ) throws -> [TargetNode: String]
}

public final class CacheGraphContentHasher: CacheGraphContentHashing {
    private let graphContentHasher: GraphContentHashing
    private let cacheProfileContentHasher: CacheProfileContentHashing
    private let contentHasher: ContentHashing

    public convenience init(
        contentHasher: ContentHashing = ContentHasher()
    ) {
        self.init(
            graphContentHasher: GraphContentHasher(contentHasher: contentHasher),
            cacheProfileContentHasher: CacheProfileContentHasher(contentHasher: contentHasher),
            contentHasher: contentHasher
        )
    }

    public init(
        graphContentHasher: GraphContentHashing,
        cacheProfileContentHasher: CacheProfileContentHashing,
        contentHasher: ContentHashing
    ) {
        self.graphContentHasher = graphContentHasher
        self.cacheProfileContentHasher = cacheProfileContentHasher
        self.contentHasher = contentHasher
    }

    public func contentHashes(
        for graph: Graph,
        cacheProfile: TuistGraph.Cache.Profile,
        cacheOutputType: CacheOutputType
    ) throws -> [TargetNode: String] {
        try graphContentHasher.contentHashes(
            for: graph,
            filter: filterHashTarget,
            additionalStrings: [
                cacheProfileContentHasher.hash(cacheProfile: cacheProfile),
                cacheOutputType.description,
            ]
        )
    }

    private func filterHashTarget(_ target: TargetNode) -> Bool {
        let isFramework = target.target.product == .framework || target.target.product == .staticFramework
        let noXCTestDependency = !target.dependsOnXCTest
        return isFramework && noXCTestDependency
    }
}
