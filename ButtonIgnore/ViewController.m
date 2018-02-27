//
//  ViewController.m
//  ButtonIgnore
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 NSLog_Zeng. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Touch.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *crazyButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.crazyButton.timeInterval = 1.0;
    
}
- (IBAction)yj_clickAction:(id)sender {
    
    NSLog(@"......");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
