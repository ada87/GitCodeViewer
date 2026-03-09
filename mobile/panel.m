#import <Foundation/Foundation.h>

@interface RepoSummary : NSObject
@property(nonatomic, assign) NSInteger repoId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger stars;
@end

@implementation RepoSummary
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray<NSDictionary *> *repos = @[
            @{ @"id": @1, @"name": @"repo-1", @"stars": @127 },
            @{ @"id": @2, @"name": @"repo-2", @"stars": @134 },
            @{ @"id": @3, @"name": @"repo-3", @"stars": @141 },
            @{ @"id": @4, @"name": @"repo-4", @"stars": @148 },
            @{ @"id": @5, @"name": @"repo-5", @"stars": @155 },
            @{ @"id": @6, @"name": @"repo-6", @"stars": @162 },
            @{ @"id": @7, @"name": @"repo-7", @"stars": @169 },
            @{ @"id": @8, @"name": @"repo-8", @"stars": @176 },
            @{ @"id": @9, @"name": @"repo-9", @"stars": @183 },
            @{ @"id": @10, @"name": @"repo-10", @"stars": @190 },
            @{ @"id": @11, @"name": @"repo-11", @"stars": @197 },
            @{ @"id": @12, @"name": @"repo-12", @"stars": @204 },
            @{ @"id": @13, @"name": @"repo-13", @"stars": @211 },
            @{ @"id": @14, @"name": @"repo-14", @"stars": @218 },
            @{ @"id": @15, @"name": @"repo-15", @"stars": @225 },
            @{ @"id": @16, @"name": @"repo-16", @"stars": @232 },
            @{ @"id": @17, @"name": @"repo-17", @"stars": @239 },
            @{ @"id": @18, @"name": @"repo-18", @"stars": @246 },
            @{ @"id": @19, @"name": @"repo-19", @"stars": @253 },
            @{ @"id": @20, @"name": @"repo-20", @"stars": @260 },
            @{ @"id": @21, @"name": @"repo-21", @"stars": @267 },
            @{ @"id": @22, @"name": @"repo-22", @"stars": @274 },
            @{ @"id": @23, @"name": @"repo-23", @"stars": @281 },
            @{ @"id": @24, @"name": @"repo-24", @"stars": @288 },
            @{ @"id": @25, @"name": @"repo-25", @"stars": @295 },
            @{ @"id": @26, @"name": @"repo-26", @"stars": @302 },
            @{ @"id": @27, @"name": @"repo-27", @"stars": @309 },
            @{ @"id": @28, @"name": @"repo-28", @"stars": @316 },
            @{ @"id": @29, @"name": @"repo-29", @"stars": @323 },
            @{ @"id": @30, @"name": @"repo-30", @"stars": @330 },
            @{ @"id": @31, @"name": @"repo-31", @"stars": @337 },
            @{ @"id": @32, @"name": @"repo-32", @"stars": @344 },
            @{ @"id": @33, @"name": @"repo-33", @"stars": @351 },
            @{ @"id": @34, @"name": @"repo-34", @"stars": @358 },
            @{ @"id": @35, @"name": @"repo-35", @"stars": @365 },
            @{ @"id": @36, @"name": @"repo-36", @"stars": @372 },
            @{ @"id": @37, @"name": @"repo-37", @"stars": @379 },
            @{ @"id": @38, @"name": @"repo-38", @"stars": @386 },
            @{ @"id": @39, @"name": @"repo-39", @"stars": @393 },
            @{ @"id": @40, @"name": @"repo-40", @"stars": @400 },
            @{ @"id": @41, @"name": @"repo-41", @"stars": @407 },
            @{ @"id": @42, @"name": @"repo-42", @"stars": @414 },
            @{ @"id": @43, @"name": @"repo-43", @"stars": @421 },
            @{ @"id": @44, @"name": @"repo-44", @"stars": @428 },
            @{ @"id": @45, @"name": @"repo-45", @"stars": @435 },
            @{ @"id": @46, @"name": @"repo-46", @"stars": @442 },
            @{ @"id": @47, @"name": @"repo-47", @"stars": @449 },
            @{ @"id": @48, @"name": @"repo-48", @"stars": @456 },
            @{ @"id": @49, @"name": @"repo-49", @"stars": @463 },
            @{ @"id": @50, @"name": @"repo-50", @"stars": @470 },
            @{ @"id": @51, @"name": @"repo-51", @"stars": @477 },
            @{ @"id": @52, @"name": @"repo-52", @"stars": @484 },
            @{ @"id": @53, @"name": @"repo-53", @"stars": @491 },
            @{ @"id": @54, @"name": @"repo-54", @"stars": @498 },
            @{ @"id": @55, @"name": @"repo-55", @"stars": @505 },
            @{ @"id": @56, @"name": @"repo-56", @"stars": @512 },
            @{ @"id": @57, @"name": @"repo-57", @"stars": @519 },
            @{ @"id": @58, @"name": @"repo-58", @"stars": @526 },
        ];
        NSMutableArray<RepoSummary *> *models = [NSMutableArray array];
        for (NSDictionary *repo in repos) {
            RepoSummary *item = [RepoSummary new];
            item.repoId = [repo[@"id"] integerValue];
            item.name = repo[@"name"];
            item.stars = [repo[@"stars"] integerValue];
            [models addObject:item];
        }
        for (RepoSummary *item in models) {
            NSLog(@"#%ld %@ (%ld)", (long)item.repoId, item.name, (long)item.stars);
        }
    }
    return 0;
}
