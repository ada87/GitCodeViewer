#import <Foundation/Foundation.h>
#include <vector>
#include <string>

struct RepoMetric {
    int id;
    std::string name;
    int stars;
};

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        std::vector<RepoMetric> metrics = {
            {1, "repo-1", 184},
            {2, "repo-2", 188},
            {3, "repo-3", 192},
            {4, "repo-4", 196},
            {5, "repo-5", 200},
            {6, "repo-6", 204},
            {7, "repo-7", 208},
            {8, "repo-8", 212},
            {9, "repo-9", 216},
            {10, "repo-10", 220},
            {11, "repo-11", 224},
            {12, "repo-12", 228},
            {13, "repo-13", 232},
            {14, "repo-14", 236},
            {15, "repo-15", 240},
            {16, "repo-16", 244},
            {17, "repo-17", 248},
            {18, "repo-18", 252},
            {19, "repo-19", 256},
            {20, "repo-20", 260},
            {21, "repo-21", 264},
            {22, "repo-22", 268},
            {23, "repo-23", 272},
            {24, "repo-24", 276},
            {25, "repo-25", 280},
            {26, "repo-26", 284},
            {27, "repo-27", 288},
            {28, "repo-28", 292},
            {29, "repo-29", 296},
            {30, "repo-30", 300},
            {31, "repo-31", 304},
            {32, "repo-32", 308},
            {33, "repo-33", 312},
            {34, "repo-34", 316},
            {35, "repo-35", 320},
            {36, "repo-36", 324},
            {37, "repo-37", 328},
            {38, "repo-38", 332},
            {39, "repo-39", 336},
            {40, "repo-40", 340},
            {41, "repo-41", 344},
            {42, "repo-42", 348},
            {43, "repo-43", 352},
            {44, "repo-44", 356},
            {45, "repo-45", 360},
            {46, "repo-46", 364},
            {47, "repo-47", 368},
            {48, "repo-48", 372},
            {49, "repo-49", 376},
            {50, "repo-50", 380},
            {51, "repo-51", 384},
            {52, "repo-52", 388},
            {53, "repo-53", 392},
            {54, "repo-54", 396},
            {55, "repo-55", 400},
            {56, "repo-56", 404},
        };
        NSMutableArray<NSString *> *lines = [NSMutableArray array];
        for (const auto &item : metrics) {
            NSString *text = [NSString stringWithFormat:@"#%d %s (%d)", item.id, item.name.c_str(), item.stars];
            [lines addObject:text];
        }
        for (NSString *line in lines) {
            NSLog(@"%@", line);
        }
    }
    return 0;
}
