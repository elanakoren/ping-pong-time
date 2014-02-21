//
//  SettingsControllerViewController.m
//  TeenFeedback
//
//  Created by pivotal on 2/20/14.
//  Copyright (c) 2014 PivotalBeach. All rights reserved.
//

#import "SettingsControllerViewController.h"

@interface SettingsControllerViewController ()
@property UITextField * textField;
@property UIButton * button;
@property UILabel * statusLabel;
@end

@implementation SettingsControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor   = [UIColor blueColor];
    UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(0,[UIApplication sharedApplication].statusBarFrame.size.height, [self.view bounds].size.width-100, 31)];
    text.backgroundColor = [UIColor whiteColor];
    self.textField = text;
    [self.view addSubview:text];
    
    UILabel * statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.textField.frame.origin.y+self.textField.frame.size.height+10, [self.view bounds].size.width, 50)];
    [self.view addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake([self.view bounds].size.width-100+10, [UIApplication sharedApplication].statusBarFrame.size.height, 80, 31);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"Update" forState: UIControlStateNormal];
    [self.view addSubview:button];
    self.button = button;

    [button addTarget:self action:@selector(buttonTouch) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonTouch {
    NSLog(@"%@", self.textField.text);
    
    NSString * endpoint = @"http://localhost:3000/name_announcements";
    
    NSURLSession *session = [NSURLSession sharedSession];
    [self.button setTitle:@"…" forState: UIControlStateNormal];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: self.textField.text, @"name",
                             [[UIDevice currentDevice].identifierForVendor UUIDString], @"phone_id",
                             nil];
    
    NSLog(@"map data: %@", mapData);
    
    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    
    NSLog(@"post data: %@", [[NSString alloc ]initWithData:postData encoding:NSUTF8StringEncoding]);
    
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSError *e = nil;
                NSDictionary * returnDictionary;
                returnDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                NSMutableDictionary *dict = [@{@"key": error} mutableCopy];
                dict[@"key"] = error;
                NSArray *array = @[@"hello", @"goodbye"];
                if ([ returnDictionary objectForKey:@"error"] != nil) {
                    self.statusLabel.text = [returnDictionary objectForKey:@"error"];
                } else if ([returnDictionary objectForKey:@"name"] != nil) {
                    self.statusLabel.text = @"";
                    self.textField.text = [returnDictionary objectForKey:@"name"];

                }
                
                [self.button setTitle:@"Complete!" forState: UIControlStateNormal];
                self.textField.text =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            }];
    }];
    [postDataTask resume];
    
}

@end
