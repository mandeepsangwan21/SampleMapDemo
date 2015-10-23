//
//  WebServiceLibrary.m
//  WebServiceLibrary
//
//  Created by Babul Prabhakar on 25/03/15.
//  Copyright (c) 2015 Babul Prabhakar. All rights reserved.
//

#import "HTTPClientUtil.h"
#import "AFHTTPRequestOperationManager.h"
//#import "FileUploadRequest.h"
//#import "InternetUtility.h"
//#import "UserDefaultController.h"
#define USER_AGENT @"Mozilla/5.0 (X11; mios) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.91 "
@interface HTTPClientUtil() {
    
}

@end
@implementation HTTPClientUtil

/*
 *@author - Babul Prabhakar
 *put request to server and put response.
 *parameters : NSString(requestUrl), NSDictionary(JSON data to send), NSString(HTTP method = "PUT")
 */
+(void)putDataToWS :(NSString *)requestUrl parameters:(NSDictionary *)parameters WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block {
    if(requestUrl != nil) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:ACCEPTANCE_DATA forHTTPHeaderField:@"Accept"];
        //experiment
//        [manager.requestSerializer setValue:[[UserDefaultController getInstance] getToken] forHTTPHeaderField:@"token"];
        NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSString *userAgent = [USER_AGENT stringByAppendingString:deviceId];
        [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"user-agent"];
        
        [headerDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:(NSString *)obj  forHTTPHeaderField:key];
        }];
        
        [manager PUT:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (block) {
                block(operation,nil);
            }
        }
         
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 if (block) {
                     block(operation ,error);
                 }
                 
             }];
    }
    
}






/*
 *@author - Babul Prabhakar
 *post request to server and post response.
 *parameters : NSString(requestUrl), NSDictionary(JSON data to send), NSString(HTTP method = "POST")
 */
+(void)postDataToWS :(NSString *)requestUrl parameters:(NSDictionary *)parameters WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block   {
    if(requestUrl != nil) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:ACCEPTANCE_DATA forHTTPHeaderField:@"Accept"];
//        [manager.requestSerializer setValue:[[UserDefaultController getInstance] getToken] forHTTPHeaderField:@"token"];
        //experiment
        NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSString *userAgent = [USER_AGENT stringByAppendingString:deviceId];
        [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"user-agent"];
        
        [headerDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:(NSString *)obj  forHTTPHeaderField:key];
        }];
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (block) {
                block(operation,nil);
            }
            
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  if (block) {
                      block(operation,error);
                  }
                  
              }];
    }
}

+(void)postDataLogOutToWS :(NSString *)requestUrl parameters:(NSDictionary *)parameters WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block   {
    //    if([InternetUtility testInternetConnection])
    //    {
    if(requestUrl != nil) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:ACCEPTANCE_DATA forHTTPHeaderField:@"Accept"];
//        [manager.requestSerializer setValue:[[UserDefaultController getInstance] getToken] forHTTPHeaderField:@"token"];
        //experiment
        NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSString *userAgent = [USER_AGENT stringByAppendingString:deviceId];
        [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"user-agent"];
        
        [headerDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:(NSString *)obj  forHTTPHeaderField:key];
        }];
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (block) {
                block(operation,nil);
            }
            
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  if (block) {
                      block(operation,error);
                  }
                  
              }];
        
    }
    //    } else {
    //
    //    }
}





/*
 *@author - Babul Prabhakar
 *get request to server and get response.
 *parameters : NSString(requestUrl), NSString(HTTP method = "GET")
 */
+(void)getDataFromWS:(NSString *)requestUrl WithHeaderDict:(NSDictionary *)headerDict  withBlock:(RequestCompletionBlock)block  {
    
    if(requestUrl != nil) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:ACCEPTANCE_DATA forHTTPHeaderField:@"Accept"];
//        [manager.requestSerializer setValue:[[UserDefaultController getInstance] getToken] forHTTPHeaderField:@"token"];
        //experiment
        NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSString *userAgent = [USER_AGENT stringByAppendingString:deviceId];
        [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"user-agent"];
        
        [headerDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:(NSString *)obj  forHTTPHeaderField:key];
        }];
        [manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (block) {
                block(operation,nil);
            }
            
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (block) {
                     block(operation,error);
                 }
                 
             }];
    }
}

/*
 *@author - Babul Prabhakar
 *delete request to server
 *parameters : NSString(requestUrl), NSString(HTTP method = "DELTE")
 */
+(void)deleteFromWS:(NSString *)requestUrl parameters:(NSDictionary *)parameters WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block {
    
    
    if(requestUrl != nil) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:ACCEPTANCE_DATA forHTTPHeaderField:@"Accept"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [headerDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:(NSString *)obj  forHTTPHeaderField:key];
        }];
        [manager DELETE:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if (block) {
                 block(operation,nil);
             }
             
         }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    if (block) {
                        block(operation,error);
                    }
                    
                }];
    }
}


/*
 *@author - Babul Prabhakar
 *post request to server and get response.
 *parameters : NSString(requestUrl), NSDictionary(JSON data to send), NSString(HTTP method = "POST")
 */
+(void)postMultiPartToWS :(NSString *)requestUrl FileUploadReq:(FileUploadRequest *)req WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block{
    
    if(requestUrl != nil && req!= nil ) {
        
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:ACCEPTANCE_DATA forHTTPHeaderField:@"Accept"];
        [manager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            
//            [formData appendPartWithFileData:req.data name:@"file" fileName:req.fileName mimeType:req.exten];
            
        }success:^(AFHTTPRequestOperation *operation, id responseObject){
            if (block) {
                block(operation,nil);
            }
        }
         
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (block) {
                      block(operation,error);
                  }
                  
              }];
        
    }
    
}



@end
