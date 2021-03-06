
//  NetworkHandler.m
//  TaxiTogether
//
//  Created by Jay on 11. 7. 5..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "NetworkHandler.h"
#import "ASIFormDataRequest.h"
#import "SBJsonParser.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "DBHandler.h"

@implementation NetworkHandler
@synthesize responseDataArray, url,queue;

-(BOOL)isNetworkReachableWithAlert:(BOOL)Alert{
    struct sockaddr_in zeroAddr;
    bzero(&zeroAddr,sizeof(zeroAddr));
    zeroAddr.sin_len=sizeof(zeroAddr);
    zeroAddr.sin_family=AF_INET;
    
    SCNetworkReachabilityRef target=SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
    
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
    
    if(flag&kSCNetworkFlagsReachable)
    {
        return YES;
    }
    else
    {
        if(Alert)
        {
            [[[[UIAlertView alloc]initWithTitle:@"연결오류" message:@"네트워크 상태를 확인해 주세요" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show]; 
        }
        return NO; 
    }
}

-(void)hasTogetherWithDelegate:(id)delegate{
    if([self isNetworkReachableWithAlert:NO])
    {
        DBHandler* dbHandler=[DBHandler getDBHandler];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:(NSURL *)[url URLByAppendingPathComponent:@"together/already_have_together/"]] ;
        [request setShouldAttemptPersistentConnection:NO];
        [request setRequestMethod:@"POST"];
        [request setDelegate:delegate];
        [request addPostValue:[dbHandler.userinfo objectForKey:@"userid"] forKey:@"userid"];
        [request addPostValue:[dbHandler.userinfo objectForKey:@"key"] forKey:@"key"];
        //[request startAsynchronous];
        [request setDidFinishSelector:@selector(requestFinished:)];
        [request setDidFailSelector:@selector(requestFailed:)];
        [[self queue] addOperation:request]; //queue is an NSOperationQueue
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        url = [[NSURL alloc]initWithString:@"http://taxi.kaist.ac.kr"];
        
    }
    
    return self;
}
+(NetworkHandler *)getNetworkHandler{
    static NetworkHandler *NetworkHandler = nil;
    
    if(NetworkHandler == nil)
    {
        @synchronized(self)
        {
            if(NetworkHandler == nil)
            {
                NetworkHandler = [[self alloc] init];
            }
        }
    }
    
    return NetworkHandler;
}


- (IBAction)grabURLInBackground:(NSString *)Path callObject:(id)callObject requestDict:(NSDictionary *)requestDict method:(NSString *)Method alert:(BOOL)Alert
{    
    
    if (![self queue]) {
        [self setQueue:[[NSOperationQueue alloc] init]];
    }
    
    if([self isNetworkReachableWithAlert:Alert])
    {
        if([Method isEqualToString:@"POST"]){
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[url URLByAppendingPathComponent:Path]];
            [request setShouldAttemptPersistentConnection:NO];
            [request setRequestMethod:Method];
            if ( requestDict != nil)
            {
                for(int i=0;i<[requestDict count];i++)
                {
                    [request setPostValue:[requestDict objectForKey:[[requestDict allKeys] objectAtIndex:i]] forKey:[[requestDict allKeys] objectAtIndex:i]];
                
                }
            }
            [request setDelegate:callObject];
           // [request startAsynchronous];
            [request setDidFinishSelector:@selector(requestFinished:)];
            [request setDidFailSelector:@selector(requestFailed:)];
            [[self queue] addOperation:request]; //queue is an NSOperationQueue
        }
        else if([Method isEqualToString:@"GET"]){
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[url URLByAppendingPathComponent:Path]];
            [request setRequestMethod:Method];
            //NSLog(Path);
            [request setDelegate:callObject];
            //[request startAsynchronous];
            [request setDidFinishSelector:@selector(requestFinished:)];
            [request setDidFailSelector:@selector(requestFailed:)];
            [[self queue] addOperation:request]; //queue is an NSOperationQueue
        }
        //NSLog(@"grab called");
    }

}
@end
