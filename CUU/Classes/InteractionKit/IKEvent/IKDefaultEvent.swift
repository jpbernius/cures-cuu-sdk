public class IKDefaultEvent: IKEvent {
    
    public var _session: String = CUUSessionManager.sharedManager.currentSession
    public var _user: String = CUUUserManager.sharedManager.userId
    public var startDate: Date = Date()
    public var endDate: Date = Date()
    public var title: String = ""
    public var type: String = ""
    
    public var parameter: [String:String] = [:]
    
}
