// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFURLClient.h"

static NSString * const AFURLClientBaseURLString = @"http://ld.liandan100.com/ldmgr/";

@implementation AFURLClient

+ (instancetype)sharedClient {
    static AFURLClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFURLClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:[NSString stringWithFormat:@"%d",VERSION_NUM] forHTTPHeaderField:@"versionNum"];
        [requestSerializer setValue:kMSScreenSize forHTTPHeaderField:@"screenSize"];
        [requestSerializer setValue:@"0" forHTTPHeaderField:@"platform"];
        [requestSerializer setValue:[MyTool getUUIDString] forHTTPHeaderField:@"mac"];//MyTool中已对uuiid加密
        [requestSerializer setValue:[MyTool getDeviceName] forHTTPHeaderField:@"deviceName"];
        [requestSerializer setValue:[MyTool getSysVersion] forHTTPHeaderField:@"os"];
        [requestSerializer setValue:[MyTool getDeviceModel] forHTTPHeaderField:@"deviceModel"];
        [requestSerializer setValue:[UserPref getUserPref:session_pref] forHTTPHeaderField:@"token"];
        _sharedClient.requestSerializer = requestSerializer;
    });
    
    return _sharedClient;
}


+ (void)handleAllHeaderFields:(NSDictionary *)header{
    NSString *session = [[header objectForKey:@"allHeaderFields"] objectForKey:@"token"];
    if(![StrUtil isEmpty:session])
    {
        [UserPref saveUserPref:session key:session_pref];
        [[AFURLClient sharedClient].requestSerializer setValue:session forHTTPHeaderField:@"token"];
    }
}

+ (NSString *)formatUrlWithUrl:(NSString *)url{
    return [url stringByAppendingFormat:@"&r=%@",[UserPref getUserPref:token_pref]];
}
@end
