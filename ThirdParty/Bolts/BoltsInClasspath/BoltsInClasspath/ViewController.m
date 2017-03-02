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
    BFCancellationTokenSource* delayedCancelSource;
    UITextView* _delegateOutputTextView;
    __block id latestResult;
    __block id latestError;
    NSArray* buttonArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructViewWithTableView];
}

- (void)_clear {
    void (^block)() = ^{
        @synchronized(_delegateOutputTextView) {
            _delegateOutputTextView.text = @"";
        }
    };
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)_printOutput:(id)format, ... {
    va_list ap;
    va_start(ap, format);
    NSString* newString = [[NSString alloc] initWithFormat:[format description] arguments:ap];
    void (^block)() = ^{
        @synchronized(_delegateOutputTextView) {
            _delegateOutputTextView.text = [_delegateOutputTextView.text stringByAppendingString:newString];
            _delegateOutputTextView.text = [_delegateOutputTextView.text stringByAppendingString:@"\n"];
            if(_delegateOutputTextView.text.length > 0 ) {
                NSRange bottom = NSMakeRange(_delegateOutputTextView.text.length -1, 1);
                [_delegateOutputTextView scrollRangeToVisible:bottom];
            }
        }
    };
    dispatch_async(dispatch_get_main_queue(), block);
    va_end(ap);
}

-(void)constructViewWithTableView {
    buttonArray = [[NSArray alloc] initWithObjects:@"Forecast Weather At Microsoft using a custom block",@"Forecast Weather At Apple using immediate BFThread Executor",
                   @"Forecast For all corner cities",@"start long task",@"cancel long task",@"Get last cancelled task",@"Get last completed task",
                   @"Get last error task",@"Notify upon any task completion",@"Forecast Weather in China after 5 seconds delay",
                   @"start delayed task with cancel token",@"cancel delayed task with cancel token", nil];
    
    //defines all views
    _delegateOutputTextView = [[UITextView alloc] init];
    _delegateOutputTextView.translatesAutoresizingMaskIntoConstraints = false;
    [_delegateOutputTextView setBackgroundColor:[UIColor whiteColor]];
    
    UIView* container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = false;
    [container setTag:000];
    
    UILabel* label1 = [[UILabel alloc] init];
    [label1 setText:@"Bolts Sample Application.\nPlease observe console for output."];
    [label1 setLineBreakMode:NSLineBreakByWordWrapping];
    [label1 setNumberOfLines:0];
    label1.translatesAutoresizingMaskIntoConstraints = false;
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    
    UITableView* APITestTableView = [[UITableView alloc] init];
    APITestTableView.delegate = self;
    APITestTableView.dataSource = self;
    APITestTableView.translatesAutoresizingMaskIntoConstraints = false;
    
    [container setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
    [APITestTableView setBackgroundColor:[UIColor grayColor]];
    
    [container addSubview:label1];
    [container addSubview:APITestTableView];
    [[self view] addSubview:container];
    [[self view] addSubview:_delegateOutputTextView];
    
    
    NSLayoutConstraint *topCLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:container
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomCLayoutConstraints = [NSLayoutConstraint constraintWithItem:container
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:_delegateOutputTextView
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1.f constant:0.f];
    NSLayoutConstraint *leftCLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:container
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.f constant:0.f];
    NSLayoutConstraint *rightCLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:container
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.f constant:0.f];
    
    NSLayoutConstraint *heightLayoutConstraints = [NSLayoutConstraint constraintWithItem:_delegateOutputTextView
                                                                               attribute:NSLayoutAttributeHeight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1.f constant:200.f];
    NSLayoutConstraint *leftTLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:_delegateOutputTextView
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.f constant:0.f];
    NSLayoutConstraint *rightTLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_delegateOutputTextView
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomTLayoutConstraints = [NSLayoutConstraint constraintWithItem:_delegateOutputTextView
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:[self view]
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.f constant:0.f];

    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label1]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(label1)]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label1(50)]" options:0 metrics:nil views: NSDictionaryOfVariableBindings(label1)]];
   
    NSDictionary *views = NSDictionaryOfVariableBindings(APITestTableView);
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[APITestTableView]|" options:0 metrics:nil views:views]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[APITestTableView]-0-|" options:0 metrics:nil views:views]];
  
    [[self view] addConstraint:topCLayoutConstraints];
    [[self view] addConstraint:bottomCLayoutConstraints];
    [[self view] addConstraint:leftCLayoutConstraints];
    [[self view] addConstraint:rightCLayoutConstraints];
    [[self view] addConstraint:heightLayoutConstraints];
    [[self view] addConstraint:leftTLayoutConstraints];
    [[self view] addConstraint:rightTLayoutConstraints];
    [[self view] addConstraint:bottomTLayoutConstraints];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:
            [self forecastAtMicrosoftButtonTapped];
            break;
        case 1:
            [self forecastAtAppleButtonTapped];
            break;
        case 2:
            [self allCornerCitiesForecastButtonTapped];
            break;
        case 3:
            [self longRunningForecastButtonTapped];
            break;
        case 4:
            [self longRunningForecastCancelButtonTapped];
            break;
        case 5:
            [self printLastCancelledTask];
            break;
        case 6:
            [self getLatestTaskWithCompletedResult];
            break;
        case 7:
            [self getLatestTaskWithError];
            break;
        case 8:
            [self getNotifiedUponCompletionOfAnyFromABunchOfTasks];
            break;
        case 9:
            [self delayFiveSecondsAndGetWeather];
            break;
        case 10:
            [self startDelayedTaskWithCancellationToken];
            break;
        case 11:
            [self delayedTaskCancelButtonTapped];
            break;
        default:
            break;
    }
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [buttonArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellID = @"buttonCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [[cell textLabel] setText:[buttonArray objectAtIndex:[indexPath row]]];
    [[cell textLabel] setTextAlignment:NSTextAlignmentLeft];
    [cell.backgroundView setBackgroundColor:[UIColor orangeColor]];
    return cell;
}

-(void)forecastAtMicrosoftButtonTapped {
    [self getCurrentWeatherAtMicrosoftRedmond];
}

-(void)forecastAtAppleButtonTapped {
    [self getCurrentWeatherAtApplePaloAlto];
}

-(void)allCornerCitiesForecastButtonTapped {
    [self _printOutput:(@"Batch processing kicked off for -------------------------------multiple cities on Mega task executor executing each task concurrently.")];
    [self findWeatherInAllCornerCitiesOfUSA];
}

-(void)longRunningForecastButtonTapped {
    cancelSource = [BFCancellationTokenSource cancellationTokenSource];
    __weak __typeof__(cancelRegistration) weakcancelEventRegistration = cancelRegistration;
    cancelRegistration = [[cancelSource token] registerCancellationObserverWithBlock:^{
        [self _printOutput:(@"token cancel event occured. This block is registered for cancel event.")];
        [weakcancelEventRegistration dispose];
    }];
    [self fetchWeatherAndWaitFiveSeconds:[cancelSource token]];
}

-(void)longRunningForecastCancelButtonTapped {
    if (cancelSource != nil) {
        [cancelSource cancel];
    }
}

- (void)findWeatherInAllCornerCitiesOfUSA {
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
            latestError = t.error;
            [self _printOutput:(t.error)];
        }else {
            if(t.result == nil) {
                [self _printOutput:(@"completed the batch processing on custom dispatch queue")];
            }
            else{
                int i = 0;
                NSArray* resultArray = t.result;
                latestResult = resultArray;
                for (NSString* result in resultArray) {
                    NSString* outputResult = [NSString stringWithFormat:@"%@ forecasted in %@.",result,[cities objectAtIndex:i]];
                    [self _printOutput:outputResult];
                    i++;
                }
            }
        }
        return nil;
    }];
}

- (void)getCurrentWeatherAtApplePaloAlto {
    TaskManager *manager = [TaskManager sharedManager];
    printf("%s", "\n\n");
    [self _printOutput:(@"processing weather report for paloalto from an immediate BFThread Executor")];
    [[manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:@"paloalto" andCountry:@"usa"] continueWithExecutor:[TaskExecutionResource immediateBFThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.error != nil) {
            latestError = t.error;
            [self _printOutput:(t.error)];
        }
        else {
            latestResult = t.result;
            [self _printOutput:(t.result)];
        }
        return nil;
    }];
}

- (void)getCurrentWeatherAtMicrosoftRedmond {
    TaskManager *manager = [TaskManager sharedManager];
    printf("%s", "\n\n");
    [self _printOutput:(@"processing weather report for redmond from a custom block.")];
    [[manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:@"redmond" andCountry:@"usa"] continueWithExecutor:[TaskExecutionResource executeBFTaskOnBlock:^{
    }] withBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.error != nil) {
            latestError = t.error;
            [self _printOutput:(t.error)];
        }
        else {
            latestResult = t.result;
            [self _printOutput:(t.result)];
        }
        return nil;
    }];
}

- (void)fetchWeatherAndWaitFiveSeconds: (BFCancellationToken*) cancelToken {
    TaskManager *manager = [TaskManager sharedManager];
    [self _printOutput:(@"started long running task. This task gets weather forecast in Moscow,Russia and waits for 5 seconds to finish.")];
    BFTask* longRunningTask = [manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:@"moscow" andCountry:@"russia"];

    __weak __typeof__(self) weakSelf = self;
    __strong __typeof__(self) strongSelf = weakSelf;
    
    [longRunningTask continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.error != nil) {
            latestError = t.error;
            [strongSelf _printOutput:(t.error)];
        }
        else {
            strongSelf->latestResult = t.result;
            NSString* resultString = [NSString stringWithFormat:@"%@ forecasted in Moscow,Russia.",t.result];
            [strongSelf _printOutput:resultString];
        }
        [NSThread sleepForTimeInterval:5];

        if (cancelToken.isCancellationRequested) {
            [strongSelf _printOutput:(@"cancel process requested. Further processing will be cancelled.")];
        }
        else{
            [strongSelf _printOutput:(@"Long running task completed.")];
        }
        return nil;
    } cancellationToken:cancelToken];

}

-(void)printLastCancelledTask {
    [self _printOutput:[BFTask cancelledTask]];
}

-(void)getLatestTaskWithCompletedResult {
    [self _printOutput:[BFTask taskWithResult:latestResult]];
}

-(void)getLatestTaskWithError {
    [self _printOutput:[BFTask taskWithError:latestError]];
}

- (void)getNotifiedUponCompletionOfAnyFromABunchOfTasks {
    NSArray* cities = [[NSArray alloc] initWithObjects:@"los angeles",@"phoenix",@"washington d.c.",@"detroit", nil];
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
    
    [[BFTask taskForCompletionOfAnyTask:tasksArray] continueWithExecutor:[TaskExecutionResource dispatchQueueBFThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull t) {
        if(t.error != nil) {
            latestError = t.error;
            NSString* resultString = [NSString stringWithFormat:@"completed one of the Tasks from a batch processing on custom dispatch queue with error: %@",t.error];
            [self _printOutput:resultString];
        }else {
            [self _printOutput:(@"completed one of the Tasks from a batch processing on custom dispatch queue")];
        }
        return nil;
    }];
}

- (void)delayFiveSecondsAndGetWeather {
    [self _printOutput:(@"processing delayed weather report for Beijing, China from an immediate BFThread Executor")];
    [[BFTask taskWithDelay:5000] continueWithExecutor:[TaskExecutionResource dispatchQueueBFThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull t) {
        TaskManager *manager = [TaskManager sharedManager];
        printf("%s", "\n\n");
        [self _printOutput:(@"processing weather report for Beijing, China from a custom block after 5 seconds delay.")];
        [[manager fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor:@"beijing" andCountry:@"China"] continueWithExecutor:[TaskExecutionResource executeBFTaskOnBlock:^{
        }] withBlock:^id _Nullable(BFTask * _Nonnull t) {
            if (t.error != nil) {
                latestError = t.error;
                [self _printOutput:(t.error)];
            }
            else {
                latestResult = t.result;
                [self _printOutput:(t.result)];
            }
            return nil;
        }];
        return nil;
    }];
}

-(void)startDelayedTaskWithCancellationToken {
    delayedCancelSource = [BFCancellationTokenSource cancellationTokenSource];
    [self delayedTaskWithCancellationToken:[delayedCancelSource token]];
}

-(void)delayedTaskCancelButtonTapped {
    if (delayedCancelSource != nil) {
        [delayedCancelSource cancel];
    }
}

- (void)delayedTaskWithCancellationToken: (BFCancellationToken*) cancelToken {
    [self _printOutput:(@"started delayed task with cancellation token.")];
    __weak __typeof__(self) weakSelf = self;
    __strong __typeof__(self) strongSelf = weakSelf;
    
    [[BFTask taskWithDelay:5000 cancellationToken:cancelToken] continueWithBlock:^id _Nullable(BFTask* _Nonnull t) {
        if (t.error != nil) {
            latestError = t.error;
            [strongSelf _printOutput:(t.error)];
        }
        else {
            strongSelf->latestResult = t.result;
            NSString* resultString = [NSString stringWithFormat:@"Finished delayed task with cancellation token."];
            [strongSelf _printOutput:resultString];
        }
        
        if (cancelToken.isCancellationRequested) {
            [strongSelf _printOutput:(@"cancel process requested. Further processing will be cancelled for the delayed task with cancellation token.")];
        }
        else{
            [strongSelf _printOutput:(@"Successfully completed delayed task with cancellation token.")];
        }
        return nil;
    }];
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
