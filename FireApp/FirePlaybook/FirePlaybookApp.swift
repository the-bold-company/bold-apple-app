import AppPlaybook
import SwiftUI

@main
struct FirePlaybookApp: App {

    @ObserveInjection private var iO
    
    var body: some Scene {
        WindowGroup {
            PlaybookCatalog(playbook: PlaybookBuilder.build())
                .id(UUID())
                .enableInjection()
            
        }
    }
}
