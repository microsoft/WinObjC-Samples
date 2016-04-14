//******************************************************************************
//
// Copyright (c) 2016 Microsoft Corporation. All rights reserved.
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
#define ADD_DIGIT(x) [resultText appendFormat:@"%d", x]

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) IBOutlet UIButton *mcButton;
@property (strong, nonatomic) IBOutlet UIButton *mplusButton;
@property (strong, nonatomic) IBOutlet UIButton *mminusButton;
@property (strong, nonatomic) IBOutlet UIButton *mrButton;
@property (strong, nonatomic) IBOutlet UIButton *acButton;
@property (strong, nonatomic) IBOutlet UIButton *signButton;

@property (strong, nonatomic) IBOutlet UIButton *divideButton;
@property (strong, nonatomic) IBOutlet UIButton *multiplyButton;
@property (strong, nonatomic) IBOutlet UIButton *subtractButton;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (strong, nonatomic) IBOutlet UIButton *equalsButton;

@property (strong, nonatomic) IBOutlet UIButton *zeroButton;
@property (strong, nonatomic) IBOutlet UIButton *decimalButton;
@property (strong, nonatomic) IBOutlet UIButton *oneButton;
@property (strong, nonatomic) IBOutlet UIButton *twoButton;
@property (strong, nonatomic) IBOutlet UIButton *threeButton;
@property (strong, nonatomic) IBOutlet UIButton *fourButton;
@property (strong, nonatomic) IBOutlet UIButton *fiveButton;
@property (strong, nonatomic) IBOutlet UIButton *sixButton;
@property (strong, nonatomic) IBOutlet UIButton *sevenButton;
@property (strong, nonatomic) IBOutlet UIButton *eightButton;
@property (strong, nonatomic) IBOutlet UIButton *nineButton;

@end

@implementation ViewController {
    NSNumber *leftOperator;
    UIButton *operationButton;
    NSMutableString *resultText;
    BOOL deleteInput;
    double memory;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    resultText = [NSMutableString stringWithString:@"0"];
    memory = 0;
    
    self.resultLabel.text = resultText;
    self.resultLabel.font = [UIFont boldSystemFontOfSize:32.0];
    self.resultLabel.textColor = [UIColor darkGrayColor];
    
    self.equalsButton.backgroundColor = [UIColor orangeColor];
    self.equalsButton.tintColor = [UIColor whiteColor];
    
    self.divideButton.backgroundColor = [UIColor lightGrayColor];
    self.divideButton.tintColor = [UIColor whiteColor];
    self.multiplyButton.backgroundColor = [UIColor lightGrayColor];
    self.multiplyButton.tintColor = [UIColor whiteColor];
    self.subtractButton.backgroundColor = [UIColor lightGrayColor];
    self.subtractButton.tintColor = [UIColor whiteColor];
    self.plusButton.backgroundColor = [UIColor lightGrayColor];
    self.plusButton.tintColor = [UIColor whiteColor];
    self.acButton.backgroundColor = [UIColor lightGrayColor];
    self.acButton.tintColor = [UIColor whiteColor];
    self.signButton.backgroundColor = [UIColor lightGrayColor];
    self.signButton.tintColor = [UIColor whiteColor];
    
    self.mcButton.backgroundColor = [UIColor blueColor];
    self.mcButton.tintColor = [UIColor whiteColor];
    self.mplusButton.backgroundColor = [UIColor blueColor];
    self.mplusButton.tintColor = [UIColor whiteColor];
    self.mminusButton.backgroundColor = [UIColor blueColor];
    self.mminusButton.tintColor = [UIColor whiteColor];
    self.mrButton.backgroundColor = [UIColor blueColor];
    self.mrButton.tintColor = [UIColor whiteColor];
}

- (void)doOperation:(UIButton*)theButton
{
    double result = 0.0;
    
    if(theButton==_equalsButton) {
        theButton = operationButton;
    }
    
    if(theButton==_multiplyButton) {
        result = [leftOperator doubleValue] * [resultText doubleValue];
    }
    
    else if(theButton==_divideButton) {
        result = [leftOperator doubleValue] / [resultText doubleValue];
    }
    
    else if(theButton==_plusButton) {
        result = [leftOperator doubleValue] + [resultText doubleValue];
    }
    
    else if(theButton==_subtractButton) {
        result = [leftOperator doubleValue] - [resultText doubleValue];
    }
    
    else if(theButton==_signButton) {
        result = [leftOperator doubleValue] * -1;
    }
    
    leftOperator = nil;
    resultText = [NSMutableString stringWithFormat:@"%f", result];
}

- (void)performOperation:(UIButton*)theButton
{
    if (leftOperator) {
        [self doOperation:theButton];
    }
    
    else {
        operationButton = theButton;
    }
    
    leftOperator = [NSNumber numberWithDouble:[resultText doubleValue]];
}

- (IBAction)buttonHandler:(id)sender
{
    UIButton *theButton = (UIButton*)sender;
    
    if (deleteInput && theButton != _signButton) {
        [resultText setString:@""];
    }
    
    deleteInput = NO;
    
    if(theButton==_mcButton) {
        memory = 0;
    }
    
    else if(theButton==_mplusButton) {
        memory += [resultText doubleValue];
        deleteInput = YES;
    }
    
    else if(theButton==_mminusButton) {
        memory -= [resultText doubleValue];
        deleteInput = YES;
    }
    
    else if(theButton==_mrButton) {
        resultText = [NSMutableString stringWithFormat:@"%f", memory];
    }
    
    else if(theButton==_acButton) {
        resultText = [NSMutableString stringWithString:@"0"];
        leftOperator = nil;
        _divideButton.backgroundColor = [UIColor lightGrayColor];
        _subtractButton.backgroundColor = [UIColor lightGrayColor];
        _multiplyButton.backgroundColor = [UIColor lightGrayColor];
        _plusButton.backgroundColor = [UIColor lightGrayColor];
    }
    
    else if(theButton==_signButton) {
        leftOperator = [NSNumber numberWithDouble:[resultText doubleValue]];
        [self performOperation:theButton];
        deleteInput = YES;
    }
    
    else if(theButton==_divideButton || theButton==_multiplyButton ||
            theButton==_subtractButton || theButton==_plusButton) {
        _divideButton.backgroundColor = [UIColor lightGrayColor];
        _subtractButton.backgroundColor = [UIColor lightGrayColor];
        _multiplyButton.backgroundColor = [UIColor lightGrayColor];
        _plusButton.backgroundColor = [UIColor lightGrayColor];
        theButton.backgroundColor = [UIColor darkGrayColor];
        
        [self performOperation:theButton];
        deleteInput = YES;
    }
    
    else if(theButton==_equalsButton) {
        _divideButton.backgroundColor = [UIColor lightGrayColor];
        _subtractButton.backgroundColor = [UIColor lightGrayColor];
        _multiplyButton.backgroundColor = [UIColor lightGrayColor];
        _plusButton.backgroundColor = [UIColor lightGrayColor];
        [self doOperation:_equalsButton];
    }
    
    else if(theButton==_zeroButton) {
        ADD_DIGIT(0);
    }
    
    else if(theButton==_oneButton) {
        ADD_DIGIT(1);
    }
    
    else if(theButton==_twoButton) {
        ADD_DIGIT(2);
    }
    
    else if(theButton==_threeButton) {
        ADD_DIGIT(3);
    }
    
    else if(theButton==_fourButton) {
        ADD_DIGIT(4);
    }
    
    else if(theButton==_fiveButton) {
        ADD_DIGIT(5);
    }
    
    else if(theButton==_sixButton) {
        ADD_DIGIT(6);
    }
    
    else if(theButton==_sevenButton) {
        ADD_DIGIT(7);
    }
    
    else if(theButton==_eightButton) {
        ADD_DIGIT(8);
    }
    
    else if(theButton==_nineButton) {
        ADD_DIGIT(9);
    }
    
    if(theButton!=_zeroButton) {
        resultText = [self readableNumberFromString:resultText];
    }
    
    if (theButton==_decimalButton) {
        [resultText appendString:@"."];
    }
    
    _resultLabel.text = resultText;
}

- (NSMutableString *)readableNumberFromString:(NSString *)aString
{
    // Remove the trailing zeros
    NSMutableString *result = [NSMutableString stringWithString:aString];
    
    // Check if it contains a . character.
    if ([result rangeOfString:@"."].location != NSNotFound) {
        
        // Start from the end, and remove any 0 or . found until number > 0
        for (long i = [result length] - 1; i >= 0; i--) {
            unichar currentChar = [result characterAtIndex:i];
            if (currentChar == '0') {
                [result replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
            }
            
            else if (currentChar == '.') {
                [result replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
                break;
            }
            
            else {
                break;
            }
        }
    }
    
    // Assign default value if needed
    if ([result isEqualToString:@""]) {
        [result appendString:@"0"];
    }
    
    // Remove the initial 0 if present
    if ([result length] > 1 && [result characterAtIndex:0] == '0') {
        [result replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    return result;
}

@end
