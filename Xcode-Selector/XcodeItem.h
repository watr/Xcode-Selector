
#import <Foundation/Foundation.h>

@interface XcodeItem : NSObject

@property (nonatomic, copy) NSString *displayName;

@property (nonatomic, copy) NSNumber *version;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSImage *image;

@property (nonatomic, copy) NSString *xcodeDeveloperPath;

@property (nonatomic, assign) BOOL selected;

+ (XcodeItem *)itemWithXcodeApplicationPath:(NSString *)path;

- (XcodeItem *)initWithXcodeApplicationPath:(NSString *)path;

@end
