let buildOperationMessageTypes: [Message.Type] = [
    BuildOperationConsoleOutputEmitted.self,
    BuildOperationDiagnosticEmitted.self,
    BuildOperationEnded.self,
    BuildOperationPreparationCompleted.self,
    BuildOperationProgressUpdated.self,
    BuildOperationReportPathMap.self,
    BuildOperationReportBuildDescription.self,
    BuildOperationStarted.self,
] + buildOperationTargetMessageTypes + buildOperationTaskMessageTypes
