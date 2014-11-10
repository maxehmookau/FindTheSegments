#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"74278bda-b644-4520-8f0c-720eaf059935"]; // Definitely need to change this when beacons arrive
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                       identifier:@"com.substrakt.findthesegments"];
    _beaconRegion.notifyEntryStateOnDisplay = YES;
    _beaconRegion.notifyOnEntry = YES;
    [_locationManager setDelegate:self];
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startMonitoringForRegion:_beaconRegion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
