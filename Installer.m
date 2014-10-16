#import "Installation.h"

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
	BOOL isN78a = [modelFile isEqualToString:@"N78a"];
	NSString *platformPathWithFile = [NSString stringWithFormat:CAM_SETUP_PLIST, modelFile];
	NSMutableDictionary *root = [[NSDictionary dictionaryWithContentsOfFile:platformPathWithFile] mutableCopy];
	if (root == nil) return NO;
	NSMutableDictionary *tuningParameters = [[root objectForKey:TUNING_PARAM] mutableCopy];
	if (tuningParameters == nil) return NO;
	NSMutableDictionary *portTypeBack = [[tuningParameters objectForKey:PORT_TYPE_BACK] mutableCopy];
	if (portTypeBack == nil) return NO;
	NSMutableDictionary *portTypeFront = [[tuningParameters objectForKey:PORT_TYPE_FRONT] mutableCopy];
	if (portTypeFront == nil) return NO;
	
	NSMutableDictionary *HDRDict = [[NSMutableDictionary dictionaryWithContentsOfFile:EXTERNAL_HDR_PLIST] mutableCopy];
	if (HDRDict == nil) return NO;
	
	for (NSString *key in [portTypeBack allKeys]) {
		NSMutableDictionary *properties = [[portTypeBack objectForKey:key] mutableCopy];
		[properties addEntriesFromDictionary:HDRDict];
		[portTypeBack setObject:properties forKey:key];
	}
	for (NSString *key in [portTypeFront allKeys]) {
		NSMutableDictionary *properties = [[portTypeFront objectForKey:key] mutableCopy];
		[properties addEntriesFromDictionary:HDRDict];
		[portTypeFront setObject:properties forKey:key];
	}
	
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
	if (!isN78a) {
		NSMutableDictionary *index1 = [[avCap objectAtIndex:1] mutableCopy];
		if (index1 == nil) return NO;
		[index1 setObject:@YES forKey:HDR_DETECTION];
		[avCap replaceObjectAtIndex:1 withObject:index1];
	}
	[index0 setObject:@YES forKey:HDR_DETECTION];
	[avCap replaceObjectAtIndex:0 withObject:index0];

	[avRoot setObject:avCap forKey:AVCAP];
	[avRoot writeToFile:avSession atomically:YES];

	return YES;
}

- (BOOL)install
{
	BOOL success = YES;
	PSLog(@"Adding Auto HDR Parameters.");
	success = [self addHDRParam];
	if (!success) {
		PSLog(@"Failed adding parameters.");
		return success;
	}
	PSLog(@"Done!");
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
