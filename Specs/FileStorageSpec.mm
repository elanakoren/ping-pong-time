#import "FileStorage.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FileStorageSpec)

describe(@"FileStorage", ^{
    __block FileStorage *fileStorage;
    __block NSString *filename;
    __block NSString *documentPath;
    __block NSArray *searchPaths;

    beforeEach(^{
        searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = [searchPaths objectAtIndex:0];
        filename = [documentPath stringByAppendingPathComponent:@"foo.txt"];
        fileStorage = [[FileStorage alloc] initWithFilename:filename];
    });

    afterEach(^{
        [[NSFileManager defaultManager] removeItemAtPath:filename  error: NULL];
    });

    it(@"should be able to write and read from the file", ^{
        [fileStorage append:@"abc"];
        [fileStorage append:@"123"];

        fileStorage = [[FileStorage alloc] initWithFilename:filename];
        NSArray * contents = [fileStorage all];
        [contents objectAtIndex:0] should equal(@"abc");
        [contents objectAtIndex:1] should equal(@"123");
    });

});

SPEC_END
