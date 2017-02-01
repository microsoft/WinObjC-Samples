//******************************************************************************
//
// Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#import "ViewController.h"
#import "TaskManager.h"
#import "TaskExecutionResource.h"


@interface ViewController () {
    BFCancellationTokenSource* cancelSource;
    BFCancellationTokenRegistration* cancelRegistration;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self constructView];
}

-(void)constructView{

    [[self view] setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];

    UILabel* label1 = [[UILabel alloc] init];
    [label1 setText:@"Bolts Sample Application.\nPlease observe console for output."];
    [label1 setLineBreakMode:NSLineBreakByWordWrapping];
    [label1 setNumberOfLines:0];
    [label1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setTextAlignment:NSTextAlignmentCenter];

    UIButton* button1 = [[UIButton alloc] init];
    [button1 setTitle:@"Forecast Weather At Microsoft" forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake(20, 120, 250, 40)];
    [button1 setBackgroundColor:[UIColor blueColor]];
    [button1 setTintColor:[UIColor blackColor]];
    [button1 addTarget:self action:@selector(forecastAtMicrosoftButtonTapped) forControlEvents:UIControlEventTouchDown];


    UIButton* button2 = [[UIButton alloc] init];
    [button2 setTitle:@"Forecast Weather At Apple" forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(20, 180, 250, 40)];
    [button2 setBackgroundColor:[UIColor blueColor]];
    [button2 setTintColor:[UIColor blackColor]];
    [button2 addTarget:self action:@selector(forecastAtAppleButtonTapped) forControlEvents:UIControlEventTouchDown];


    UIButton* button3 = [[UIButton alloc] init];
    [button3 setTitle:@"Forecast For all corner cities" forState:UIControlStateNormal];
    [button3 setFrame:CGRectMake(20, 240, 250, 40)];
    [button3 setBackgroundColor:[UIColor blueColor]];
    [button3 setTintColor:[UIColor blackColor]];
    [button3 addTarget:self action:@selector(allCornerCitiesForecastButtonTapped) forControlEvents:UIControlEventTouchDown];


    UIButton* button4 = [[UIButton alloc] init];
    [button4 setTitle:@"start long task" forState:UIControlStateNormal];
    [button4 setFrame:CGRectMake(20, 300, 250, 40)];
    [button4 setBackgroundColor:[UIColor blueColor]];
    [button4 setTintColor:[UIColor blackColor]];
    [button4 addTarget:self action:@selector(longRunningForecastButtonTapped) forControlEvents:UIControlEventTouchDown];
    [button4 setTag:111];


    UIButton* button5 = [[UIButton alloc] init];
    [button5 setTitle:@"cancel long task" forState:UIControlStateNormal];
    [button5 setFrame:CGRectMake(20, 360, 250, 40)];
    [button5 setBackgroundColor:[UIColor blueColor]];
    [button5 setTintColor:[UIColor blackColor]];
    [button5 addTarget:self action:@selector(longRunningForecastCancelButtonTapped) forControlEvents:UIControlEventTouchDown];
    [button5 setTag:222];
    [button5 setAlpha:0.3];
    [button5 setUserInteractionEnabled:false];

    [[self view] addSubview:button1];
    [[self view] addSubview:button2];
    [[self view] addSubview:button3];
    [[self view] addSubview:button4];
    [[self view] addSubview:button5];
    [[self view] addSubview:label1];

    label1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTop multiplier:1.0 constant:40].active = true;
    [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20].active = true;
    [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20].active = true;
    [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80].active = true;
}

-(void)forecastAtMicrosoftButtonTapped {
    [self getCurrentWeatherAtMicrosoftRedmond];
}

-(void)forecastAtAppleButtonTapped {
    [self getCurrentWeatherAtApplePaloAlto];
}

-(void)allCornerCitiesForecastButtonTapped {
    // executes all tasks in one BFTask
    NSLog(@"Batch processing kicked off for -------------------------------multiple cities on Mega task executor executing each task concurrently.");
    [self findWeatherInAllCornerCitiesOfUSA];
}

-(void)longRunningForecastButtonTapped {
    for (UIView* subView in [[self view] subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            if ([(UIButton*)subView tag]  == 111) {
              dispatch_async(dispatch_get_main_queue(),^{
                [subView setUserInteractionEnabled:false];
                [subView setAlpha:0.3];
              });
            }
            if ([(UIButton*)subView tag]  == 222) {
              dispatch_async(dispatch_get_main_queue(),^{
                [subView setUserInteractionEnabled:true];
                [subView setAlpha:1.0];
              });
            }
        }
    }
    cancelSource = [BFCancellationTokenSource cancellationTokenSource];
    __weak __typeof__(cancelRegistration) weakcancelEventRegistration = cancelRegistration;
    cancelRegistration = [[cancelSource token] registerCancellationObserverWithBlock:^{
        NSLog(@"token cancel event occured. This block is registered for cancel event.");
        [weakcancelEventRegistration dispose];
    }];
    [self fetchWeatherAndWaitFiveSeconds:[cancelSource token]];
}

-(void)longRunningForecastCancelButtonTapped {
    for (UIView* subView in [[self view] subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            if ([(UIButton*)subView tag]  == 111 || [(UIButton*)subView tag]  == 222) {
              dispatch_async(dispatch_get_main_queue(),^{
                [subView setUserInteractionEnabled:false];
                [subView setAlpha:0.3];
              });
            }
        }
    }
    if (cancelSource != nil) {
        [cancelSource cancel];
    }
}

- (void)findWeatherInAllCornerCitiesOfUSA{
    NSArray* cities = [[NSArray alloc] initWithObjects:@"seattle",@"sandiego",@"miami",@"boston", nil];
    NSMutableArray* tasksArray = [NSMutableArray array];
    TaskManager *manager = [TaskManager sharedManager];
    BFTask* task1 = [manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:[cities objectAtIndex:0] andCountry:@"usa"];
    BFTask* task2 = [manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:[cities objectAtIndex:1] andCountry:@"usa"];
    BFTask* task3 = [manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:[cities objectAtIndex:2] andCountry:@"usa"];
    BFTask* task4 = [manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:[cities objectAtIndex:3] andCountry:@"usa"];

    [tasksArray addObject:task1];
    [tasksArray addObject:task2];
    [tasksArray addObject:task3];
    [tasksArray addObject:task4];

    [[BFTask taskForCompletionOfAllTasksWithResults:tasksArray] continueWithExecutor:[TaskExecutionResource dispatchQueueBFThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull t) {
        if(t.error != nil) {
            NSLog(@"%@",t.error);
        }else {
            if(t.result == nil) {
                NSLog(@"completed the batch processing on custom dispatch queue");
                printf("%s", "\n\n");
            }
            else{
                int i = 0;
                NSArray* resultArray = t.result;
                for (NSString* result in resultArray) {
                    NSLog(@"%@ forecasted in %@.",result,[cities objectAtIndex:i]);
                    i++;
                }
            }
        }
        return nil;
    }];
}

- (void)getCurrentWeatherAtApplePaloAlto{
    TaskManager *manager = [TaskManager sharedManager];
    printf("%s", "\n\n");
    NSLog(@"processing weather report for paloalto from an immediate BFThread Executor");
    [[manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:@"paloalto" andCountry:@"usa"] continueWithExecutor:[TaskExecutionResource immediateBFThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.error != nil) {
            NSLog(@"%@", t.error);
        }
        else {
            NSLog(@"%@ forecasted at Apple.",(NSString*)t.result);
        }
        return nil;
    }];
}

- (void)getCurrentWeatherAtMicrosoftRedmond{
    TaskManager *manager = [TaskManager sharedManager];
    printf("%s", "\n\n");
    NSLog(@"processing weather report for redmond from a custom block.");
    [[manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:@"redmond" andCountry:@"usa"] continueWithExecutor:[TaskExecutionResource executeBFTaskOnBlock:^{
    }] withBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.error != nil) {
            NSLog(@"%@", t.error);
        }
        else {
            NSLog(@"%@ forecasted at Microsoft.",t.result);
        }
        return nil;
    }];
}

- (void)fetchWeatherAndWaitFiveSeconds: (BFCancellationToken*) cancelToken{
    TaskManager *manager = [TaskManager sharedManager];
    printf("%s", "\n\n");
    NSLog(@"started long running task.");
    BFTask* longRunningTask = [manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:@"moscow" andCountry:@"russia"];

    __weak __typeof__(self) weakSelf = self;
    [longRunningTask continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.error != nil) {
            NSLog(@"%@", t.error);
        }
        else {
            NSLog(@"%@ forecasted in Moscow,Russia.",t.result);
        }
        [NSThread sleepForTimeInterval:5];

        if (cancelToken.isCancellationRequested) {
            NSLog(@"cancel process rquested. Further processing will be cancelled.");
        }
        else{
            NSLog(@"Long running task completed.");
        }

        for (UIView* subView in [[weakSelf view] subviews]) {
            if ([subView isKindOfClass:[UIButton class]]) {
                if ([(UIButton*)subView tag]  == 111) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [subView setUserInteractionEnabled:true];
                        [subView setAlpha:1.0];
                    });
                }
                if ([(UIButton*)subView tag]  == 222) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [subView setUserInteractionEnabled:false];
                        [subView setAlpha:0.3];
                    });
                }
            }
        }
        return nil;
    } cancellationToken:cancelToken];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#ifdef WINOBJC
// Tell the WinObjC runtime how large to render the application
@implementation UIApplication (UIApplicationInitialStartupMode)
+ (void)setStartupDisplayMode:(WOCDisplayMode*)mode {
    mode.autoMagnification = TRUE;
    mode.sizeUIWindowToFit = TRUE;
    mode.fixedWidth = 0;
    mode.fixedHeight = 0;
    mode.magnification = 1.0;
}
@end
#endif
