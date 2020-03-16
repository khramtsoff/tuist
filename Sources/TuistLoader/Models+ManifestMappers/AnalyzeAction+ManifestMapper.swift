import Basic
import Foundation
import ProjectDescription
import TuistCore

extension TuistCore.AnalyzeAction {
    static func from(manifest: ProjectDescription.AnalyzeAction,
                     generatorPaths _: GeneratorPaths) throws -> TuistCore.AnalyzeAction {
        let configurationName = manifest.configurationName

        return AnalyzeAction(configurationName: configurationName)
    }
}