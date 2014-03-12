#import <Foundation/Foundation.h>
#include <sys/sysctl.h>

#define PORT_TYPE_FRONT @"PortTypeFront"
#define PORT_TYPE_BACK @"PortTypeBack"
#define HDR_DETECTION @"highDynamicRangeSceneDetectionSupported"
#define DEFAULT_SENSOR_ID @"DefaultSensorIDs"
#define TUNING_PARAM @"TuningParameters"
#define EXTERNAL_HDR_PLIST @"/Library/AutoHDREnabler/HDRscene.plist"
#define AVCAP @"AVCaptureDevices"
#define CAM_SETUP_PLIST @"/System/Library/Frameworks/MediaToolbox.framework/%@/CameraSetup.plist"
#define AVCAP_SESSION_PLIST @"/System/Library/Frameworks/MediaToolbox.framework/%@/AVCaptureSession.plist"
#define PSLog(...) printf("%s\n", [[NSString stringWithFormat:__VA_ARGS__] UTF8String])

@interface AutoHDRInstaller : NSObject
@end

@interface AutoHDRRemover : NSObject
@end
