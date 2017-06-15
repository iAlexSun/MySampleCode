//
//  ViewController.m
//  JSConnectOC-02
//
//  Created by Alex on 17/2/17.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>
//tianbai对象调用的JavaScript方法，必须声明！！！
- (void)call;
- (void)getCall:(NSString *)callString;

@end

/**
 *  1.JSContext：给JavaScript提供运行的上下文环境
    2.JSValue：JavaScript和Objective-C数据和方法的桥梁
    3.JSExport：这是一个协议，如果采用协议的方法交互，自己定义的协议必须遵守此协议
 */

@interface ViewController ()<UIWebViewDelegate,JSObjcDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    self.webView.delegate = self;
    //从本地加载html文件
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
}


//网页加载完毕

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 设置javaScriptContext上下文
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //将tianbai对象指向自身
    self.jsContext[@"tianbai"] = self;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

//将对象指向自身后，如果调用 tianbai.call() 会响应下面的方法，OC方法中调用js中的Callback方法，并传值
- (void)call{
    NSLog(@"call");
  
    // 之后在回调js的方法Callback把内容传出去
    JSValue *Callback = self.jsContext[@"Callback"];

    //传值给web端
    [Callback callWithArguments:@[@"唤起本地OC回调完成"]];
}

//将对象指向自身后，如果调用 ` tianbai.getCall(callInfo)` 会响应下面的方法，OC方法中仅调用js中的alerCallback方法

- (void)getCall:(NSString *)callString{
    NSLog(@"Get:%@", callString);
    
    // 成功回调js的方法Callback
    JSValue *Callback = self.jsContext[@"alerCallback"];
   
    [Callback callWithArguments:nil];
    
}

//将对象指向自身后，还可以向html注入js

- (void)alert{
    
    // 直接添加提示框
    NSString *str = @"alert('OC添加JS提示成功')";
    [self.jsContext evaluateScript:str];
    
}

@end
