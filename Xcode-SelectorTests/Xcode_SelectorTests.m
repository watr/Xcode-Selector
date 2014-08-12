
#import <XCTest/XCTest.h>
#import "XcodeHelper.h"

@interface Xcode_SelectorTests : XCTestCase

@end

@implementation Xcode_SelectorTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testXcodeExists
{
    XCTAssert([XcodeHelper xcodeApplicationPathsExceptOtherVolumes:YES].count > 0, @"There is no Xcode path.");
}

- (void)testSelectedXcodePathIsExists
{
    NSString *selectedXcodePath = [XcodeHelper selectedXcodePath];
    XCTAssert(selectedXcodePath.length > 0, @"Selected Xcode path NOT exists.");
}

@end
