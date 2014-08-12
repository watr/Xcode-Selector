
#import "XcodeHelper.h"
#import "STPrivilegedTask.h"

@implementation XcodeHelper

+ (NSString *)selectedXcodePath
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/xcode-select"];
    [task setArguments:@[@"-p"]];
    NSPipe *outPipe = [NSPipe pipe];
    [task setStandardOutput:outPipe];
    
    NSFileHandle *fileHandle = [outPipe fileHandleForReading];
    [task launch];
    [task waitUntilExit];
    
    NSData *data = [fileHandle readDataToEndOfFile];
    NSString *outString = [[[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    return outString;
}

+ (NSArray *)xcodeApplicationPathsExceptOtherVolumes:(BOOL)except;
{
    NSMutableArray *xcodePaths = [@[] mutableCopy];
    MDQueryRef query = MDQueryCreate(NULL,
                                     (__bridge CFStringRef)(@"kMDItemKind == 'Application' &&"
                                                            "kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode"),
                                     NULL,
                                     NULL);
    if (MDQueryExecute(query,
                       kMDQuerySynchronous))
    {
        NSInteger resultCount = MDQueryGetResultCount(query);
        for (NSInteger i = 0; i < resultCount; i++) {
            MDItemRef const item = (MDItemRef const)MDQueryGetResultAtIndex(query,
                                                     i);
            NSString *path = (__bridge_transfer NSString *)MDItemCopyAttribute(item, kMDItemPath);
            if (path &&
                ((! except) ||
                 (! [path hasPrefix:@"/Volumes/"])))
            {
                    [xcodePaths addObject:path];
            }
        }
    }
    return (xcodePaths.count > 0 ? [NSArray arrayWithArray:xcodePaths] : nil);
}

+ (NSString *)xcodeTitleWithApplicationPath:(NSString *)xcodeApplicaionPath
{
    NSBundle *xcodeApplicationBundle = [NSBundle bundleWithPath:xcodeApplicaionPath];
    __block NSString *title = nil;
    if (xcodeApplicationBundle) {
        NSDictionary *info = [xcodeApplicationBundle infoDictionary];
        NSString *versionString = [info objectForKey:@"CFBundleShortVersionString"];
        
        title = [NSString stringWithFormat:@"%@ (%@)", [[NSFileManager defaultManager] displayNameAtPath:xcodeApplicaionPath], versionString];
    }
    else {
        [[xcodeApplicaionPath pathComponents] enumerateObjectsWithOptions:NSEnumerationReverse
                                                               usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                   NSString *component = (NSString *)obj;
                                                                   if ([[component pathExtension] isEqualToString:@"app"]) {
                                                                       title = component;
                                                                       *stop = YES;
                                                                   }
                                                               }];
    }
    return title;
}

+ (NSString *)xcodeDeveloperDirectoryPathCreateWithApplicationPath:(NSString *)xcodeApplicationPath
{
    return [[xcodeApplicationPath stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Developer"];
}

+ (BOOL)selectXcodeDeveloperDirectoryPath:(NSString *)developerDirectoryPath
{
    [STPrivilegedTask launchedPrivilegedTaskWithLaunchPath:@"/usr/bin/xcode-select"
                                                 arguments:@[@"-s", developerDirectoryPath]];
    BOOL succeeded = ({
        NSString *selectedXcodePath = [XcodeHelper selectedXcodePath];
        ([developerDirectoryPath isEqualToString:selectedXcodePath]);
    });
    return succeeded;
}


@end
