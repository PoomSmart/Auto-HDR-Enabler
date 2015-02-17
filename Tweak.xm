#import <substrate.h>
#import <AVFoundation/AVFoundation.h>
#import "../PS.h"

extern "C" Boolean MGGetBoolAnswer(CFStringRef);
MSHook(Boolean, MGGetBoolAnswer, CFStringRef string)
{
	#define k(key) CFEqual(string, CFSTR(key))
	if (k("RearFacingCameraAutoHDRCapability") || k("FrontFacingCameraAutoHDRCapability"))
		return YES;
	return _MGGetBoolAnswer(string);
}

%hook AVCaptureDevice

- (BOOL)isHighDynamicRangeSceneDetectionSupported
{
	return YES;
}

%end

%hook AVCaptureDevice_FigRecorder

- (BOOL)isHighDynamicRangeSceneDetectionSupported
{
	return YES;
}

%end

%hook AVCaptureFigVideoDevice

- (BOOL)isHighDynamicRangeSceneDetectionSupported
{
	return YES;
}

%end

%hook AVCaptureFigVideoDevice_FigRecorder

- (BOOL)isHighDynamicRangeSceneDetectionSupported
{
	return YES;
}

%end

CGFloat ISO;

%hook CAMCaptureController

- (BOOL)isHDRSuggested
{
	return ISO <= 400.0f;
}

- (BOOL)_setupCamera
{
	BOOL r = %orig;
	[self addObserver:self forKeyPath:@"currentDevice.ISO" options:NSKeyValueObservingOptionNew context:@"PLCameraControllerSuggestedHDR2ObserverContext"];
	return r;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"currentDevice.ISO"]) {
		if ([[self delegate] _HDRMode] == 2 && [%c(CAMCaptureController) isStillImageMode:self.cameraMode]) {
			ISO = [change[NSKeyValueChangeNewKey] floatValue];
			[self _suggestedHDRChanged];
		}
	} else
		%orig;
}

- (void)_destroyCamera
{
	if (MSHookIvar<AVCaptureSession *>(self, "_avCaptureSession") != nil)
		[self removeObserver:self forKeyPath:@"currentDevice.ISO"];
	%orig;
}

%end

//FigCFCreatePropertyListFromBundleIdentifierOnPlatform // com.apple.MediaToolbox AVCaptureSession.plist

%ctor
{
	%init;
	MSHookFunction(MGGetBoolAnswer, MSHake(MGGetBoolAnswer));
}
