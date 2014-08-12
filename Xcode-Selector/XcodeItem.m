
#import "XcodeItem.h"
#import "XcodeHelper.h"

@interface NSBundle (InfoDictionary)

- (NSNumber *)version;

@end


@implementation NSBundle (InfoDictionary)

- (NSNumber *)version;
{
    NSBundle *bundle = self;
    NSDictionary *info = [bundle infoDictionary];
    NSNumber *versionNumber = [info objectForKey:@"CFBundleVersion"];
    return versionNumber;
}

@end

@interface XcodeItem ()

+ (NSImage *)imageWithXcodePath:(NSString *)path;

@end

@implementation XcodeItem

+ (XcodeItem *)itemWithXcodeApplicationPath:(NSString *)path
{
    return [[self alloc] initWithXcodeApplicationPath:path];
}

- (XcodeItem *)initWithXcodeApplicationPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.displayName = [[NSFileManager defaultManager] displayNameAtPath:path];
        self.version = [[NSBundle bundleWithPath:path] version];
        self.title = [XcodeHelper xcodeTitleWithApplicationPath:path];
        self.image = [[self class] imageWithXcodePath:path];
        self.xcodeDeveloperPath  = [XcodeHelper xcodeDeveloperDirectoryPathCreateWithApplicationPath:path];
    }
    return self;
}

#pragma mark class extension

+ (NSImage *)imageWithXcodePath:(NSString *)path
{
    NSImage *image = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        image = [[NSWorkspace sharedWorkspace] iconForFile:path];
    }
    else {
        NSImage *notFoundImage = [[NSImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericQuestionMarkIcon.icns"];
        image = notFoundImage;
    }
    return image;
}


@end
