//
//  ViewController.m
//  TeenFeedback
//
//  Created by pivotal on 2/19/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "ViewController.h"
//#import "Counter.h"
//#import "HTAutocompleteTextField.h"
//#import "WordSource.h"

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel* label;
//@property (nonatomic, strong) Counter * counter;
//@property (nonatomic, strong) WordSource * wordSource;
@end

@implementation ViewController


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.counter = [[Counter alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
//    self.wordSource = [[WordSource alloc] init];
//    [self.wordSource canUpdateNow];
//    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    HTAutocompleteTextField *textField = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake(
//        0,statusBarHeight,[self.view bounds].size.width,31
//    )];
//    
//    textField.backgroundColor = [UIColor whiteColor];
//    textField.autocompleteDataSource = self.wordSource;
//    textField.delegate = self;
//    
//	// Do any additional setup after loading the view.
//    
//    self.view.backgroundColor   = [UIColor redColor];
//    [self.view addSubview:textField];

}

//-(void) redraw
//{
//    self.label.text = [NSString stringWithFormat:@"Hello INT: %d", [self.counter count]];
//}
//
//-(void) aMethod
//{
//    [self.counter inc];
//    [self redraw];
//}



@end
