public struct PlanningOperationDidFinish: SessionMessage {
    public static let name = "PLANNING_OPERATION_FINISHED"

    public var sessionHandle: String
    public var planningOperationHandle: String
    
    public init(sessionHandle: String, planningOperationHandle: String) {
        self.sessionHandle = sessionHandle
        self.planningOperationHandle = planningOperationHandle
    }
}
