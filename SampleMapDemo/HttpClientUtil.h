//
//  WebServiceLibrary.h
//  WebServiceLibrary
//
//  Created by Babul Prabhakar on 25/03/15.
//  Copyright (c) 2015 Babul Prabhakar. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ACCEPTANCE_DATA  @"application/json"
#define CONTENT_TYPE @"application/json"
@class AFHTTPRequestOperation;
@class FileUploadRequest;
@interface HTTPClientUtil : NSObject
typedef void (^RequestCompletionBlock)(AFHTTPRequestOperation* operation, NSError *error);

/*
 *@author - Babul Prabhakar
 *put request to server and put response.
 *parameters : NSString(requestUrl), NSDictionary(JSON data to send), NSString(HTTP method = "PUT")
 */
+(void)putDataToWS :(NSString *)requestUrl parameters:(NSDictionary *)parameters WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block;
/*
 *@author - Babul Prabhakar
 *post request to server and post response.
 *parameters : NSString(requestUrl), NSDictionary(JSON data to send), NSString(HTTP method = "POST")
 */
+(void)postDataToWS :(NSString *)requestUrl parameters:(NSDictionary *)parameters WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block ;
/*
 *@author - Babul Prabhakar
 *get request to server and get response.
 *parameters : NSString(requestUrl), NSString(HTTP method = "GET")
 */
+(void)getDataFromWS:(NSString *)requestUrl WithHeaderDict:(NSDictionary *)headerDict  withBlock:(RequestCompletionBlock)block ;

+(void)postDataLogOutToWS :(NSString *)requestUrl parameters:(NSDictionary *)parameters WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block ;
/*
 *@author - Babul Prabhakar
 *delete request to server
 *parameters : NSString(requestUrl), NSString(HTTP method = "DELTE")
 */
+(void)deleteFromWS:(NSString *)requestUrl parameters:(NSDictionary *)parameters WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block;

/*
 *@author - Babul Prabhakar
 *post request to server and get response.
 *parameters : NSString(requestUrl), NSDictionary(JSON data to send), NSString(HTTP method = "POST")
 */

+(void)postMultiPartToWS :(NSString *)requestUrl FileUploadReq:(FileUploadRequest *)req WithHeaderDict:(NSDictionary *)headerDict withBlock:(RequestCompletionBlock)block;
@end
