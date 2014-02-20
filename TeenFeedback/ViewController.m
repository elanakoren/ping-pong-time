//
//  ViewController.m
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "ViewController.h"
#import "Counter.h"
#import "HTAutocompleteTextField.h"
#import "WordSource.h"

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) Counter * counter;
@property (nonatomic, strong) WordSource * wordSource;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"Nib");
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.counter = [[Counter alloc] init];
    self.wordSource = [[WordSource alloc] init];
    [self.wordSource canUpdateNow];
    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    HTAutocompleteTextField *textField = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake(
        0,statusBarHeight,[self.view bounds].size.width,31
    )];
    UITextView  *txt = [[UITextView  alloc]init];
    txt.frame = CGRectMake(0, 31+statusBarHeight+5, [self.view bounds].size.width, 150);
    textField.backgroundColor = [UIColor whiteColor];
    textField.autocompleteDataSource = self.wordSource;
    textField.delegate = self;
    self.label = [[UILabel alloc] initWithFrame:
                  CGRectMake(0.0f, 200, self.view.bounds.size.width, 100.0f)];
    self.label.text = [NSString stringWithFormat:@"Hello INT: %d", [self.counter count]];

	// Do any additional setup after loading the view.
    self.view.backgroundColor   = [UIColor redColor];
    self.label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.label];
    [self.view addSubview:textField];
    [self.view addSubview:txt];
    
    
    CGRect frame = CGRectMake(0, 300, 200, 30);
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myButton.frame = frame;
    myButton.backgroundColor = [UIColor blueColor];
    [myButton setTitle:@"+1" forState   :UIControlStateNormal];
    [self.view addSubview:myButton];
    [myButton addTarget:self
                 action:@selector(aMethod)
       forControlEvents:UIControlEventTouchUpInside];

}

-(void) redraw
{
    self.label.text = [NSString stringWithFormat:@"Hello INT: %d", [self.counter count]];
}

-(void) aMethod
{
    [self.counter inc];
    [self redraw];
}



@end
