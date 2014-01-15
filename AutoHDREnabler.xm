#import <substrate.h>

Boolean (*old_MGGetBoolAnswer)(CFStringRef);
Boolean replaced_MGGetBoolAnswer(CFStringRef string)
{
	#define k(key) CFEqual(string, CFSTR(key))
	if (k("RearFacingCameraAutoHDRCapability") || k("FrontFacingCameraAutoHDRCapability"))
		return YES;
	return old_MGGetBoolAnswer(string);
}


%ctor
{
	MSHookFunction(((BOOL *)MSFindSymbol(NULL, "_MGGetBoolAnswer")), (BOOL *)replaced_MGGetBoolAnswer, (BOOL **)&old_MGGetBoolAnswer);
}


/*@interface CAMBottomBar : UIView
@end

%hook CAMBottomBar

// {320,101.5}
- (CGSize)sizeThatFits:(CGSize)fits
{
	CGSize r = %orig;
	NSLog(@"%@ to %@", NSStringFromCGSize(fits), NSStringFromCGSize(r));
	return r;
}

// - (void)_layoutForHorizontalOrientation
{
	%orig;
	self.frame = CGRectMake(0, 50,300,300);
}

%end

%hook CAMTopBar

- (CGSize)sizeThatFits:(CGSize)fits
{
	CGSize r = %orig;
	NSLog(@"%@ to %@", NSStringFromCGSize(fits), NSStringFromCGSize(r));
	return r;
}

- (void)HDRButtonWillExpand:(id)ex
{
	%orig;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + 50, self.frame.size.height);
}
- (void)HDRButtonDidCollapse:(id)co
{
	%orig;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width - 50, self.frame.size.height);
}

%end*/