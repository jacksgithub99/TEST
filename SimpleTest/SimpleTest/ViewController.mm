//
//  ViewController.m
//  SimpleTest
//
//  Created by Jack's MacBook Air on 15/11/20.
//  Copyright © 2015年 Jack's MacBook Air. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>
#import "UIViewController+swizzling.h"

#import "StockData.h"
#import "JKObject.h"
#import "AudioVC.h"
#import "NoneARC.h"
#import "ImagePickerController.h"

@interface ViewController ()
{
    StockData *_stockForKVO;
    
    CGFloat _aNewPrice;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ViewController

-(void)loadView
{
    [super loadView];
    
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setFrame:CGRectMake(100.f, 330.f, 100.f, 40.f)];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn setTitle:@"button" forState:UIControlStateNormal];
    [btn addTarget:self action:NSSelectorFromString(@"btnClicked:") forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSRunLoop
    NSOperation *op;
//    [self fileHandlerTest];
    
    [self addMaskLayer];
    
    [self runtimeTest];
    
    [self kvoTest];
    
    [self cTest];
    
    _aNewPrice = 0;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(funcccc:) name:UIKeyboardWillHideNotification object:nil];
    
    NSLog(@"\n【%@】",[(NSString *)self uppercaseString]);
    
    JKObject *obj = [[JKObject alloc] init];
    
    [obj handleUrl:@"" completion:^(NSData *data) {
        
    }];
    
    
    [[[NoneARC alloc] init] noneARCTest];
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear");
//    
//    [self blockTest];
//

- (void)func:(NSInteger)aNumber withBlock:(void(^)(BOOL finished))theBlock{

};




-(void)blockTest
{
    NSMutableArray *mArray = [NSMutableArray arrayWithObjects:@"a",@"b",@"abc",nil];
    NSMutableArray *mArrayCount = [NSMutableArray arrayWithCapacity:1];
    [mArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock: ^(id obj,NSUInteger idx, BOOL *stop){
        [mArrayCount addObject:[NSNumber numberWithInt:[obj length]]];
    }];
    
    
    __block NSInteger num = 8;
    __block NSString *astr = @"";//要修改值、必须要__block
    
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:@"jack"];
    
    void (^myblock)(void) = ^(){
        
        num++;
        
        astr = @"jack";
        
        [mStr appendString:@"_mStr"];
    };
    
    myblock();
    
    NSLog(@"blockTest:%@,%@",astr,mStr);
    
//    CALayer *layer0;11


}

-(void)funcccc:(NSNotification *)notification{}


-(id)forwardingTargetForSelector:(SEL)aSelector
{
    NSString *selectorStr = NSStringFromSelector(aSelector);
    if ([selectorStr isEqualToString:@"uppercaseString"]) {
        return @"uper case string";
    }
    
    
    return [super forwardingTargetForSelector:aSelector];
}

-(void)fileHandlerTest
{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = array[0];
    
    NSLog(@"%@",documentDirectory);
    
    NSString *textPath = [documentDirectory stringByAppendingPathComponent:@"jkdoc.text"];
    
    NSLog(@"%@",textPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSData *data = [@"...JK..." dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileManager createFileAtPath:textPath contents:data attributes:nil];
    
    NSData *readData = [NSData dataWithContentsOfFile:textPath];
    
    NSString *str = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    
    NSLog(@"[[[[[[[[[[[[[[[[%@",str);
}

-(void)kvoTest
{
    _stockForKVO = [[StockData alloc] init];
    [_stockForKVO setValue:@"searph" forKey:@"stockName"];
    [_stockForKVO setValue:@"10.0" forKey:@"price"];
    [_stockForKVO addObserver:self forKeyPath:@"price" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"price"]) {
        NSLog(@"new price is %f",[[_stockForKVO valueForKey:keyPath] floatValue]);
    }
    
    NSLog(@"objcet:%@",object);
    
    NSLog(@"change:%@",change);
}

-(void)runtimeTest
{
    unsigned int count;
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
    }
    
    free(propertyList);
    
    //获取方法列表
    Method *methodList = class_copyMethodList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
    }
    
    //获取成员变量列表
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
    }
    
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
    
}

-(void)addMaskLayer
{
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    //
    CGFloat maskX = 50.f;
    CGFloat triangleMaxX = maskX+20.f;
    CGFloat maskY = 50.f;
    CGFloat triangleMinY = maskY+20.f;
    CGFloat triangleMidY = triangleMinY+15.f;
    CGFloat triangleMaxY = triangleMidY+15.f;
    CGFloat cornerRadius = 8.f;
    CGFloat maskMaxX = 200.f;
    CGFloat maskMaxY = 200.f;
    //
    BOOL clockWise = YES;
    CGFloat startAngle = M_PI_2*0;
    CGFloat angle0 = [self angleAtIndex:0 startAngle:startAngle];
    CGFloat angle1 = [self angleAtIndex:1 startAngle:startAngle];
    
    CGFloat angle2 = [self angleAtIndex:2 startAngle:startAngle];
    CGFloat angle3 = [self angleAtIndex:3 startAngle:startAngle];
    
    CGFloat angle4 = [self angleAtIndex:4 startAngle:startAngle];
    CGFloat angle5 = [self angleAtIndex:5 startAngle:startAngle];
    
    CGFloat angle6 = [self angleAtIndex:6 startAngle:startAngle];
    CGFloat angle7 = [self angleAtIndex:7 startAngle:startAngle];
    
    
    maskPath.lineCapStyle = kCGLineCapRound; //线条拐角
    maskPath.lineJoinStyle = kCGLineJoinRound; //终点处理
    //
    [maskPath moveToPoint:CGPointMake(maskX, triangleMidY)];
    [maskPath addLineToPoint:CGPointMake(triangleMaxX, triangleMinY)];
    [maskPath addLineToPoint:CGPointMake(triangleMaxX, maskY)];
    
    //    [maskPath addArcWithCenter:CGPointMake(triangleMaxX+cornerRadius, maskY+cornerRadius) radius:cornerRadius startAngle:angle0 endAngle:angle1 clockwise:clockWise];
    
    //    [maskPath moveToPoint:CGPointMake(triangleMaxX+cornerRadius, maskY)];
    [maskPath addLineToPoint:CGPointMake(maskMaxX-cornerRadius, maskY)];
    
    [maskPath addLineToPoint:CGPointMake(maskMaxX-cornerRadius, maskY)];
    [maskPath addArcWithCenter:CGPointMake(maskMaxX-cornerRadius, maskY+cornerRadius) radius:cornerRadius startAngle:M_PI_2*3 endAngle:M_PI_2*4 clockwise:clockWise];
    [maskPath moveToPoint:CGPointMake(maskMaxX-cornerRadius, maskY)];
    
    [maskPath addLineToPoint:CGPointMake(maskMaxX, maskY+cornerRadius)];
    [maskPath addLineToPoint:CGPointMake(maskMaxX, maskMaxY-cornerRadius)];
    
    [maskPath addLineToPoint:CGPointMake(maskX, triangleMidY)];
    maskPath.lineJoinStyle = kCGLineJoinRound;
    
    
    //
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    _contentView.layer.mask = maskLayer;
    
    NSURLConnection *c;
    
    
}

-(CGFloat)angleAtIndex:(NSInteger)index startAngle:(CGFloat)sAngle
{
    CGFloat resultAngle = sAngle+M_PI_2*index;
    
    while (1) {
        if (resultAngle > M_PI*2) {
            resultAngle = resultAngle-M_PI*2;
        }else
        {
            break;
        }
    }
    
    return resultAngle;
}

-(void)btnClicked:(id)sender
{
    
//    [self kvoTest2];
    
//    [self goAudioVC];
    
    
    [self goImagePickerController];
}

- (void)goImagePickerController
{
    ImagePickerController *vc = [[ImagePickerController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

-(void)kvoTest2
{
    [_stockForKVO setValue:[NSString stringWithFormat:@"%.1f",_aNewPrice] forKey:@"price"];
    
    _aNewPrice = _aNewPrice+1;
    
    
    
    static int count = 0;
    
    
    count ++;

}

-(void)goAudioVC
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:[NSBundle mainBundle]];
    
    AudioVC *vc = [sb instantiateViewControllerWithIdentifier:@"AudioVC"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cTest
{
    int *p = (int *)malloc(sizeof(int)*100);
    
    memset(p, 0, sizeof(int)*100);
    
    
    //    char *q = new char(100);
    
    char q[100] = {'A'};
    
    for (int i = 0; i < 100; i++) {
        printf("-%c",q[i]);
    }
    
    char *s = new char(10);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
