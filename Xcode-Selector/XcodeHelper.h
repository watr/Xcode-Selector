
#import <Foundation/Foundation.h>

@interface XcodeHelper : NSObject

+ (NSArray *)xcodeApplicationPathsExceptOtherVolumes:(BOOL)except;

+ (NSString *)selectedXcodePath;

+ (NSString *)xcodeTitleWithApplicationPath:(NSString *)xcodeApplicaionPath;

+ (NSString *)xcodeDeveloperDirectoryPathCreateWithApplicationPath:(NSString *)xcodeApplicationPath;

+ (BOOL)selectXcodeDeveloperDirectoryPath:(NSString *)developerDirectoryPath;

@end
