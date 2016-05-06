//
//  ViewController.m
//  ChildApp
//
//  Created by Vladyslav Gusakov on 1/23/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.activityIndicatorView.hidden = YES;
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// ------ location manager
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(nonnull CLLocation *)newLocation fromLocation:(nonnull CLLocation *)oldLocation {
    CLLocation *currentLocation = newLocation;
    NSLog(@"%@", currentLocation);
    
    coordinate = [newLocation coordinate];
    NSLog(@"latitude:%f", coordinate.latitude);
    NSLog(@"longitude:%f", coordinate.longitude);
    NSLog(@"location updated");
    
    
}


// ------ Start Button Clicked method
- (void)sendRequest {
    
    self.childDict =
    @{
      @"utf8": @"✓",
      @"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=",
      @"user":
          @{
              @"username":self.userNameText.text,
              @"current_lat":[NSString stringWithFormat:@"%f", coordinate.latitude],
              @"current_longitude":[NSString stringWithFormat:@"%f", coordinate.longitude]
              },
      @"commit":@"Create User",
      @"action":@"update",
      @"controller":@"users"
      };
    
    NSError *error;
    jsonData = [NSJSONSerialization dataWithJSONObject:self.childDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/%@",
                                       [self.userNameText.text lowercaseString]]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"PATCH"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%@", jsonString] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];


}

- (void) showActivityIndicator {
    
    self.activityIndicatorView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.activityIndicatorView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.activityIndicatorView startAnimating];
        
    }];
}

- (void) hideActivityIndicator {
    self.activityIndicatorView.hidden = YES;

    [UIView animateWithDuration:0.3 animations:^{
        self.activityIndicatorView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.activityIndicatorView stopAnimating];
        
    }];
}

- (IBAction)switchButtonValueChanged:(id)sender {
    
        if (self.switchButton.on) {
            if ([self.userNameText.text  isEqual: @""]) {
                [self.switchButton setOn:NO animated:YES];
                UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"Enter username"
                                                                                        message:@"username is missing" preferredStyle: UIAlertControllerStyleAlert];
                [self presentViewController:alerController animated:YES completion:nil];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                     {
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [alerController addAction:ok];

                
            }
            else {
                [self.locationManager startUpdatingLocation];
                [self showActivityIndicator];
                self.sendingLocationLabel.text = @"Sending location";
        
                [self sendRequest];
            }
        
        }
        else {
            [self.locationManager stopUpdatingLocation];
            [self hideActivityIndicator];
            self.sendingLocationLabel.text = @"";
        }
    


}

@end
