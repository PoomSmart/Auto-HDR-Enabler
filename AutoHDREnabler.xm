#import <substrate.h>

Boolean (*old_MGGetBoolAnswer)(CFStringRef);
Boolean replaced_MGGetBoolAnswer(CFStringRef string)
{
	#define k(key) CFEqual(string, CFSTR(key))
	if (k("RearFacingCameraAutoHDRCapability") || k("FrontFacingCameraAutoHDRCapability"))
		return YES;
	return old_MGGetBoolAnswer(string);
}

%hook AVCaptureDevice

- (BOOL)isHighDynamicRangeSceneDetectionSupported
{
	return YES;
}

%end

%hook AVCaptureFigVideoDevice

- (BOOL)isHighDynamicRangeScene
{
	return YES;
}

- (void)_setHighDynamicRangeScene:(BOOL)yes
{
	%orig(YES);
}

- (BOOL)_setHighDynamicRangeSceneDetectionEnabled:(BOOL)arg1
{
	return YES;
}

%end

%ctor
{
	%init;
	MSHookFunction(((BOOL *)MSFindSymbol(NULL, "_MGGetBoolAnswer")), (BOOL *)replaced_MGGetBoolAnswer, (BOOL **)&old_MGGetBoolAnswer);
}
