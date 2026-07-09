//
//  JailbreakDetection.m
//  DVIA - Damn Vulnerable iOS App (damnvulnerableiosapp.com)
//  Created by Prateek Gianchandani on 25/11/17.
//  Copyright © 2018 HighAltitudeHacks. All rights reserved.
//  You are free to use this app for commercial or non-commercial purposes
//  You are also allowed to use this in trainings
//  However, if you benefit from this project and want to make a contribution, please consider making a donation to The Juniper Fund (www.thejuniperfund.org/)
//  The Juniper fund is focusing on Nepali workers involved with climbing and expedition support in the high mountains of Nepal. When a high altitude worker has an accident (death or debilitating injury), the impact to the family is huge. The juniper fund provides funds to the affected families and help them set up a sustainable business.
//  For more information,  visit www.thejuniperfund.org
//  Or watch this video https://www.youtube.com/watch?v=HsV6jaA5J2I
//  And this https://www.youtube.com/watch?v=6dHXcoF590E
 

#import <Foundation/Foundation.h>
#import "JailbreakDetection.h"

@implementation JailbreakDetection

+(BOOL)isJailbroken{
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    // 1. Array of traditional AND modern rootless paths
    NSArray *suspiciousPaths = @[
        // Traditional Rootful Paths
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/usr/sbin/sshd",
        @"/etc/apt",
        
        // Modern Rootless Paths (palera1n, Dopamine, etc.)
        @"/var/jb/Applications/Sileo.app",
        @"/var/jb/Applications/Zebra.app",
        @"/var/jb/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/var/jb/usr/lib/TweakInject",
        @"/var/jb/usr/bin/bash",
        @"/var/jb/usr/sbin/sshd",
        @"/var/jb/etc/apt",
        @"/usr/lib/libhooker.dylib",
        @"/var/jb/usr/lib/libellekit.dylib"
    ];
    
    for (NSString *path in suspiciousPaths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    
    // 2. Symlink Check for Rootless
    NSError *symlinkError = nil;
    NSString *symlinkDest = [[NSFileManager defaultManager] destinationOfSymbolicLinkAtPath:@"/var/jb" error:&symlinkError];
    if (symlinkDest != nil) {
        return YES; // Highly indicative of a rootless jailbreak
    }
    
    // 3. Sandbox Write Check
    NSError *error;
    NSString *stringToBeWritten = @"This is a test.";
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES
                          encoding:NSUTF8StringEncoding error:&error];
    if(error == nil){
        // Device is jailbroken
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
        return YES;
    }
    
    // 4. Modern URL Scheme Checks
    NSArray *suspiciousSchemes = @[
        @"cydia://package/com.example.package",
        @"sileo://",
        @"zbra://",
        @"filza://"
    ];
    
    for (NSString *scheme in suspiciousSchemes) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
            return YES;
        }
    }
    
#endif
    
    // All checks have failed. Most probably, the device is not jailbroken
    return NO;
}

@end