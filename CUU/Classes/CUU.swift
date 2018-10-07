public class CUU {
    
    // - MARK: Attributes
    /**
     * The active configuration of CUU.
     */
    private(set) public static var configuration = CUUConfiguration()
    
    /**
     * The shared InteractionKit instance.
     */
    public static var iKit: InteractionKit {
        return InteractionKit.shared
    }
    
    /**
     * The shared BehaviorKit instance.
     */
    public static var bKit: BehaviorKit {
        return BehaviorKit.shared
    }
    
    /**
     * Starts CUU.
     */
    public static func start() {
        CUU.configuration = configuration
        
        // Check if we already asked before.
        if let options = UserDefaults.standard.array(forKey: CUUConstants.CUUUserDefaultsKeys.optionsKey) as? [Int] {
            let values = options.map({ CUUStartOption(rawValue: $0) })
            startKits(with: values)
        } else {
            // We did not ask before, so do it now.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                guard let currentVC = CUUUtils.getTopViewController() else { return }
                let startVC = CUUStartViewController()
                currentVC.present(startVC, animated: true, completion: nil)
            }
        }
    }
    
    static func startKits(with options: [CUUStartOption?]) {
        if options.contains(.Features) {
            FeatureKit.start()
        }
        
        if options.contains(.Interactions) {
            iKit.configure(with: configuration.interactionKitConfiguration)
            
            iKit.start()
        }
        
        if options.contains(.Behavior) {
            bKit.configure(with: configuration.behaviorKitConfiguration)
            
            bKit.start()
        }
        
        if options.contains(.Notes) {
            NoteKit.start()
        }
    }
    
    /**
     * Stops CUU.
     */
    public static func stop() {
        FeatureKit.stop()
        iKit.stop()
        bKit.stop()
        NoteKit.stop()
    }
}
