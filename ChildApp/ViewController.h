//
//  ViewController.h
//  ChildApp
//
//  Created by Vladyslav Gusakov on 1/23/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, NSURLConnectionDataDelegate>
{
    CLLocationCoordinate2D coordinate;
    NSData *jsonData;
    NSString *jsonString;
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (strong, nonatomic) NSDictionary *childDict;
@property (weak, nonatomic) NSNumber *latitude;
@property (weak, nonatomic) NSNumber *longitude;
- (IBAction)switchButtonValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *sendingLocationLabel;

@end

