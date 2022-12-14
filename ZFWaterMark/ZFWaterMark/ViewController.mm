//
//  ViewController.m
//  ZFWaterMark
//
//  Created by 郑峰 on 2022/11/16.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <sqlite3.h>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/core/core.hpp>
#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core.hpp>
#import <opencv2/highgui.hpp>
#import <opencv2/imgproc.hpp>
#import <opencv2/photo.hpp>

@interface Person : NSObject
@end
@implementation Person
@end

@interface Student : Person

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger weight;



@end
@implementation Student
- (instancetype)init{
    if (self= [super init]) {
        NSLog(@"%@", [self class]);
        NSLog(@"%@", [super class]);
        NSLog(@"%@", [self superclass]);
        NSLog(@"%@", [super superclass]);
    }
    return self;
}
@end

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ViewController {
   sqlite3 *_db;    // 句柄
}

// 打开数据库
- (void)openSqlDataBase {
    // _db是数据库的句柄,即数据库的象征,如果对数据库进行增删改查,就得操作这个示例
    
    // 获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"fileNamePath = %@",fileName);
    // 将 OC 字符串转换为 C 语言的字符串
    const char *cFileName = fileName.UTF8String;
    
    // 打开数据库文件(如果数据库文件不存在,那么该函数会自动创建数据库文件)
    int result = sqlite3_open(cFileName, &_db);
    
    if (result == SQLITE_OK) {  // 打开成功
        NSLog(@"成功打开数据库");
    } else {
        NSLog(@")打开数据库失败");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *picPath = [[NSBundle mainBundle] pathForResource:@"man" ofType:@"jpg"];
    UIImage *inputImage = [UIImage imageWithContentsOfFile:picPath];
    cv::Mat imageMat;
    UIImageToMat(inputImage,imageMat,false);
    
//    cv::inpaint();
    
    UIImage *outputImage = MatToUIImage(imageMat);
    Student *student = [[Student alloc] init];
    student.age = 27;
    student.height = 178;
    student.weight = 125;
    Person *person = [[Person alloc] init];
    
//    [self openSqlDataBase];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    BOOL flag = NO;
//    [userdefault setObject:@(flag) forKey:@"flag"];
    [userdefault setBool:flag forKey:@"flag"];

    if ([userdefault objectForKey:@"flag"]) {
        id td = [userdefault objectForKey:@"flag"];
//        BOOL eq = [userdefault objectForKey:@"flag"];
        BOOL eq = [userdefault valueForKey:@"flag"];
        if (eq) {
            NSLog(@"a");
        }else{
            NSLog(@"b");
        }
    }else{
        BOOL eq = [userdefault objectForKey:@"flag"];
        if (eq) {
            NSLog(@"c");
        }else{
            NSLog(@"d");
        }
    }

    BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [[Person class] isKindOfClass:[NSObject class]];
    BOOL res4 = [[Person class] isMemberOfClass:[NSObject class]];
    BOOL res5 = [person isKindOfClass:[Person class]];
    BOOL res6 = [person isMemberOfClass:[Person class]];
    
//    dispatch_queue_t conQueue = dispatch_queue_create("printABC.conQueue", DISPATCH_QUEUE_CONCURRENT);
////    conQueue.
//    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
//    for (int i = 0; i < 10; i++) {
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_async(conQueue, ^{
//            NSLog(@"summit print: %c thread: %@", 'A'+i%3, [NSThread currentThread]);
//            dispatch_semaphore_signal(sema);
//        });
//    }
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    self.array = [[NSMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("cn.chutong.www", DISPATCH_QUEUE_CONCURRENT);
    //生产
    dispatch_async(queue, ^{
        while (YES) {
            int count = random()%10;
            sleep(1);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [self.array addObject:[NSString stringWithFormat:@"%d",count]];
            dispatch_semaphore_signal(semaphore);
            NSLog(@"生产了%d",count);
        }
    });
    //消费
    dispatch_async(queue, ^{
        while (YES) {
            if (self.array.count>0) {
                NSLog(@"消费了%@",self.array.lastObject);
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                [self.array removeLastObject];
                dispatch_semaphore_signal(semaphore);
            }
            
        }
    });

    unsigned int count = 0;
    Ivar *list = class_copyIvarList([student class], &count);
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (int i = 0; i< count; i++){
        id iVarName = [NSString stringWithUTF8String:ivar_getName(list[i])];
        dict[iVarName] = [student valueForKey:iVarName];
    }
        
    NSLog(@"%@",dict);
    
    UIImageView *originView = [[UIImageView alloc] initWithImage:inputImage];
    originView.frame = CGRectMake(0, 100, 300, 300);
    originView.backgroundColor = UIColor.redColor;
    originView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:originView];
    
    UIImageView *resultView = [[UIImageView alloc] initWithImage:inputImage];
    resultView.frame = CGRectMake(0, 450, 300, 300);
    resultView.backgroundColor = UIColor.redColor;
    resultView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:resultView];
    
    NSLog(@"");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

@end
