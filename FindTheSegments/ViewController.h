#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

@property (nonatomic) IBOutlet UIView *blueBeaconView;
@property (nonatomic) IBOutlet UIView *redBeaconView;
@property (nonatomic) IBOutlet UIView *greenBeaconView;
@property (nonatomic) IBOutlet UIView *yellowBeaconView;

@property (nonatomic) AVAudioPlayer *player;

@property (nonatomic, strong) NSMutableDictionary *appState;

- (void)didStandImmediatelyNextToBeacon:(CLBeacon *)beacon;
- (void)updateView;

- (IBAction)didPressResetButton:(id)sender;

@end

