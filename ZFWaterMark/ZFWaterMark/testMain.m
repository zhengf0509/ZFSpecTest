#import <UIKit/UIKit.h>
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int age = 10;
        int height = 10;
        //声明block变量
        void(^myBlock)(void) = ^{
            NSLog(@"age is %d height is %d",age,height);
        };
        //调用block
        myBlock();
    }
    return 0;
}