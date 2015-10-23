//
//  MapsSelector.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 23/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "MapsSelector.h"
#import "AppleMapsViewController.h"
#import "ViewController.h"
@interface MapsSelector ()

@end

@implementation MapsSelector

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)googleMapsButtonAction:(id)sender {
    ViewController *baseViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:baseViewController animated:YES];

    
}
- (IBAction)appleMapsButtonAction:(id)sender {
    AppleMapsViewController *baseViewController = [[AppleMapsViewController alloc] initWithNibName:@"AppleMapsViewController" bundle:nil];
    [self.navigationController pushViewController:baseViewController animated:YES];
    

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
