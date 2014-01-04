#import	"Installation.h"

@implementation AutoHDRInstaller

- (NSString *)getSysInfoByName:(char *)typeSpecifier
{
	size_t size;
	sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
	char *answer = (char *)malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString* results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
	free(answer);
	return results;
}

- (NSString *)modelAP
{
	return [self getSysInfoByName:"hw.model"];
}

- (NSString *)modelFile
{
	return [[self modelAP] stringByReplacingOccurrencesOfString:@"AP" withString:@""];
}

- (BOOL)addHDRParam
{
	NSString *modelFile = [self modelFile];
	NSString *platformPathWithFile = [NSString stringWithFormat:CAM_SETUP_PLIST, modelFile];
	NSMutableDictionary *root = [[NSDictionary dictionaryWithContentsOfFile:platformPathWithFile] mutableCopy];
	if (root == nil) return NO;
	NSMutableDictionary *tuningParameters = [[root objectForKey:TUNING_PARAM] mutableCopy];
	if (tuningParameters == nil) return NO;
	NSMutableDictionary *portTypeBack = [[tuningParameters objectForKey:PORT_TYPE_BACK] mutableCopy];
	if (portTypeBack == nil) return NO;
	NSMutableDictionary *portTypeFront = [[tuningParameters objectForKey:PORT_TYPE_FRONT] mutableCopy];
	if (portTypeFront == nil) return NO;
    NSMutableDictionary *defaultSensorIDs = [[tuningParameters objectForKey:DEFAULT_SENSOR_ID] mutableCopy];
    if (defaultSensorIDs == nil) return NO;
	NSString *portTypeFrontString = (NSString *)[defaultSensorIDs objectForKey:PORT_TYPE_FRONT];
	if (portTypeFrontString == nil) return NO;
	NSString *portTypeBackString = (NSString *)[defaultSensorIDs objectForKey:PORT_TYPE_BACK];
	if (portTypeBackString == nil) return NO;
	
	NSMutableDictionary *cameraPropertiesFront = nil;
	NSMutableDictionary *cameraPropertiesBack = nil;
	cameraPropertiesBack = [[portTypeBack objectForKey:portTypeBackString] mutableCopy];
	cameraPropertiesFront = [[portTypeFront objectForKey:portTypeFrontString] mutableCopy];
	
	NSMutableDictionary *HDRDict = [[NSMutableDictionary dictionaryWithContentsOfFile:EXTERNAL_HDR_PLIST] mutableCopy];
	if (HDRDict == nil) return NO;
	if ([cameraPropertiesBack objectForKey:@"HDRscene_hist_exp"] == nil)
		[cameraPropertiesBack addEntriesFromDictionary:HDRDict];
	if ([cameraPropertiesFront objectForKey:@"HDRscene_hist_exp"] == nil)
		[cameraPropertiesFront addEntriesFromDictionary:HDRDict];

	[portTypeBack setObject:cameraPropertiesBack forKey:portTypeBackString];
	[portTypeFront setObject:cameraPropertiesFront forKey:portTypeFrontString];
	[tuningParameters setObject:portTypeBack forKey:PORT_TYPE_BACK];
	[tuningParameters setObject:portTypeFront forKey:PORT_TYPE_FRONT];
	[root setObject:tuningParameters forKey:TUNING_PARAM];
	[root writeToFile:platformPathWithFile atomically:YES];
	
	NSString *avSession = [NSString stringWithFormat:AVCAP_SESSION_PLIST, modelFile];
    NSMutableDictionary *avRoot = [[NSMutableDictionary dictionaryWithContentsOfFile:avSession] mutableCopy];
    if (avRoot == nil) return NO;
    NSMutableArray *avCap = [[avRoot objectForKey:AVCAP] mutableCopy];
	if (avCap == nil) return NO;
	NSMutableDictionary *index0 = [[avCap objectAtIndex:0] mutableCopy];
	if (index0 == nil) return NO;
	NSMutableDictionary *index1 = [[avCap objectAtIndex:1] mutableCopy];
	if (index1 == nil) return NO;
	[index0 setObject:[NSNumber numberWithBool:YES] forKey:HDR_DETECTION];
	if (![modelFile isEqualToString:@"N78a"])
		[index1 setObject:[NSNumber numberWithBool:YES] forKey:HDR_DETECTION];
   	
	[avCap replaceObjectAtIndex:0 withObject:index0];
	[avCap replaceObjectAtIndex:1 withObject:index1];
	[avRoot setObject:avCap forKey:AVCAP];
	[avRoot writeToFile:avSession atomically:YES];

	return YES;
}

- (BOOL)install
{
	BOOL success = YES;
	NSLog(@"Adding Auto HDR Parameters.");
	success = [self addHDRParam];
	if (!success) {
		NSLog(@"Failed adding parameters.");
		return success;
	}
	NSLog(@"Done!");
	return success;
}

@end


int main(int argc, char **argv, char **envp) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	AutoHDRInstaller *installer = [[AutoHDRInstaller alloc] init];
	BOOL success = [installer install];
	[installer release];
	[pool release];
	return (success ? 0 : 1);
}
