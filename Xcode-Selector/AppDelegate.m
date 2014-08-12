
#import "AppDelegate.h"
#import "XcodeItem.h"
#import "XcodeHelper.h"

@interface AppDelegate ()

- (void)reload;

@end

@implementation AppDelegate

#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self reload];
    
    [self.window center];
    [self.window makeKeyAndOrderFront:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

#pragma mark NSTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    [self.selectButton setEnabled:((self.xcodeItemsController.selectedObjects.count == 1) &&
                                   (! ((XcodeItem *)self.xcodeItemsController.selectedObjects[0]).selected))];
}

#pragma mark -

- (IBAction)realoadAction:(id)sender {
    [self reload];
}

- (IBAction)selectAction:(id)sender {
    XcodeItem *item =
    self.xcodeItemsController.selectedObjects[0];
    
    if (item) {
        NSString *selectedXcodePath = [XcodeHelper selectedXcodePath];
        if (! [selectedXcodePath isEqualToString:item.xcodeDeveloperPath]) {
            BOOL result = [XcodeHelper selectXcodeDeveloperDirectoryPath:item.xcodeDeveloperPath];
            (void)result;
            [self reload];
        }
    }
}

#pragma mark class extension

- (void)reload
{
    NSString *selectedXcodePath = [XcodeHelper selectedXcodePath];
    __block BOOL currentSelectedXcodeNotFound = YES;
    
    [self.xcodeItemsController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.xcodeItemsController.arrangedObjects count])]];
    
    [[XcodeHelper xcodeApplicationPathsExceptOtherVolumes:YES] enumerateObjectsUsingBlock:
     ^(NSString *xcodeApplicationPath, NSUInteger idx, BOOL *stop) {
         XcodeItem *item = [XcodeItem itemWithXcodeApplicationPath:xcodeApplicationPath];
         
         BOOL isSelected = [selectedXcodePath hasPrefix:xcodeApplicationPath];
         item.selected = isSelected;
         [self.xcodeItemsController addObject:item];
         
         if (isSelected) {
             currentSelectedXcodeNotFound = NO;
             [self.xcodeItemsController setSelectedObjects:@[item]];
         }
     }];
    
    if (currentSelectedXcodeNotFound) {
        XcodeItem *item = [XcodeItem itemWithXcodeApplicationPath:selectedXcodePath];
        item.selected = YES;
        [self.xcodeItemsController addObject:item];
        [self.xcodeItemsController setSelectedObjects:@[item]];
    }
}

@end
