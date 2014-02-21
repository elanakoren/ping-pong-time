#import "Counter.h"
#import "FakeUserDefaults.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CounterSpec)

describe(@"Counter", ^{
    __block Counter *counter;

    beforeEach(^{
        counter = [[Counter alloc] initWithUserDefaults:[[FakeUserDefaults alloc] init]];
    });

    it(@"should increment the count", ^{
        [counter inc];
        [counter count] should equal(1);
    });

});

SPEC_END