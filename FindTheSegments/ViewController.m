#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"collect"
                                         ofType:@"WAV"]];
    [self updateView];
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc]
                                   initWithContentsOfURL:url
                                   error:&error];
    _appState = [@{@1: @NO,
                   @2: @NO,
                   @3: @NO,
                   @4: @NO} mutableCopy];
    _locationManager = [CLLocationManager new];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"74278bda-b644-4520-8f0c-720eaf059935"]; // Definitely need to change this when beacons arrive
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                       identifier:@"com.substrakt.findthesegments"];
    _beaconRegion.notifyEntryStateOnDisplay = YES;
    _beaconRegion.notifyOnEntry = YES;
    [_locationManager setDelegate:self];
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startMonitoringForRegion:_beaconRegion];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    switch (state) {
        case CLRegionStateInside:
            [self locationManager:_locationManager didEnterRegion:region];
            break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [_locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"%@", beacons);
    for (CLBeacon *beacon in beacons) {
        if (beacon.proximity == CLProximityImmediate) {
            [self didStandImmediatelyNextToBeacon:beacon];
        }
    }
}

- (void)didStandImmediatelyNextToBeacon:(CLBeacon *)beacon {
    if ([_appState[beacon.minor] isEqual:@NO]) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"You are stood right next to a beacon!";
        notification.alertAction = @"keep searching!";
        notification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        [_player play];
    }
    _appState[beacon.minor] = @YES;
    NSLog(@"Stood next to a beacon");
    NSLog(@"%@", _appState);
    [self updateView];
//    AVSpeechUtterance *speech = [[AVSpeechUtterance alloc] initWithString:@"You are stood next to beacon with minor number 3"];
//    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//    [synth speakUtterance:speech];
}

- (void)updateView {
    if ([_appState[@1] isEqual:@YES]) {
        _redBeaconView.backgroundColor = [UIColor redColor];
    } else {
        _redBeaconView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
    }
    
    if ([_appState[@4] isEqual:@YES]) {
        _blueBeaconView.backgroundColor = [UIColor blueColor];
    } else {
        _blueBeaconView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.3];
    }
    
    if ([_appState[@5] isEqual:@YES]) {
        _yellowBeaconView.backgroundColor = [UIColor yellowColor];
    } else {
        _yellowBeaconView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.3];
    }

    if ([_appState[@2] isEqual:@YES]) {
        _greenBeaconView.backgroundColor = [UIColor greenColor];
    } else {
        _greenBeaconView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didPressResetButton:(id)sender {
    NSLog(@"Reset");
    _appState = [@{@1: @NO,
                  @2: @NO,
                  @3: @NO,
                  @4: @NO} mutableCopy];
    [self updateView];
}

@end
