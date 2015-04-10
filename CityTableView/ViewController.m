//
//  ViewController.m
//  CityTableView
//
//  Created by apple on 15/4/10.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import "ViewController.h"
#import "CityDic.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cityName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"%@",[CityDic allCity]);
//    NSLog(@"%@",[CityDic allProvince]);
//    NSLog(@"%@",[CityDic allCityByProvince][@"吉林省"][5]);
//    NSLog(@"%@",[CityDic allCityByWordDic][@""][1]);
//    NSLog(@"%@",[CityDic allCityPyNemeDic][@"zj"][3]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCity:(id)sender {
    NSArray *array = [CityDic selectCity:_cityName.text];
    if (array.count <= 0) {
        NSLog(@"没找到");
    }
    for (NSInteger i = 0; i < array.count; i++) {
        NSLog(@"%@",array[i]);
    }
    NSLog(@"----");
}
@end
