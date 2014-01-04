#import <Foundation/Foundation.h>

%hook PLCameraController

- (BOOL)supportsHDRSuggestion
{
	return YES;
}

- (BOOL)supportsHDRSuggestionForCaptureDevice:(id)device
{
	return YES;
}

- (BOOL)supportsHDRForDevice:(id)device mode:(int)mode
{
	return (mode == 0 || mode == 4) ? YES : %orig;
}

%end

/*@interface CAMBottomBar : UIView
@end

@interface CAMTopBar : UIView
@end

%hook CAMBottomBar

// {320,101.5}
- (CGSize)sizeThatFits:(CGSize)fits
{
	CGSize r = %orig;
	NSLog(@"%@ to %@", NSStringFromCGSize(fits), NSStringFromCGSize(r));
	return r;
}

// - (void)_layoutForHorizontalOrientation{%orig; self.frame = CGRectMake(0, 50,300,300);}

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