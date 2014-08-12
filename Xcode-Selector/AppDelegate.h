
#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate>

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSButton *selectButton;

@property (strong) IBOutlet NSArrayController *xcodeItemsController;

- (IBAction)realoadAction:(id)sender;

- (IBAction)selectAction:(id)sender;

@end
