//
//  ViewController.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 21/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
//#import "HTTPClientUtil.h"
//#import <ASIHTTPRequest/ASIHTTPRequest.h>
//AIzaSyCXpnwGPeGoVQOzfv9H3tN_pj4F8tGqq20
@interface ViewController () <GMSMapViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *path;
}
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *source;

@property (weak, nonatomic) IBOutlet UITextField *destination;
@property (nonatomic) CLLocationCoordinate2D sourceLoc;
@property (nonatomic) CLLocationCoordinate2D destinationLoc;
@end

@implementation ViewController
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
double latitude = 0, longitude = 0;
NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
if (result) {
    NSScanner *scanner = [NSScanner scannerWithString:result];
    if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
        [scanner scanDouble:&latitude];
        if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
            [scanner scanDouble:&longitude];
        }
    }
}
CLLocationCoordinate2D center;
center.latitude=latitude;
center.longitude = longitude;
NSLog(@"View Controller get Location Logitute : %f",center.latitude);
NSLog(@"View Controller get Location Latitute : %f",center.longitude);
return center;

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)getRoutes:(id)sender {
//    self.source.text = @"Noida Sector 63 B-96";
//    self.destination.text = @"Kalkaji f block delhi";
    if(!(self.source.text.length == 0) && !(self.destination.text.length == 0)) {
//        [self.mapView removeFromSuperview];
//        [self.view addSubview:self.mapView];
        self.sourceLoc  =  [self getLocationFromAddressString:self.source.text];
        self.destinationLoc = [self getLocationFromAddressString:self.destination.text];
        [self googleDirectionAPI];
        [self placeMarkers];                
    }
}

-(void)googleDirectionAPI {
    AFHTTPClient *_httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://maps.googleapis.com/"]];
    [_httpClient registerHTTPOperationClass: [AFJSONRequestOperation class]];
    [_httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f", self.sourceLoc.latitude, self.sourceLoc.longitude] forKey:@"origin"];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f", self.destinationLoc.latitude, self.destinationLoc.longitude] forKey:@"destination"];    [parameters setObject:@"true" forKey:@"sensor"];
    [parameters setObject:@"AIzaSyAu5daWQlveQWV4fD6qN31xL4YY1OLB3vM" forKey:@"key"];
    
    
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"GET" path: @"maps/api/directions/json" parameters:parameters];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    AFHTTPRequestOperation *operation = [_httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id response) {
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 200) {
            [self parseResponse:response];
            [self plotPolyLines];
        } else {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [_httpClient enqueueHTTPRequestOperation:operation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.source.delegate = self;
    self.destination.delegate = self;
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.accessibilityElementsHidden = NO;
    self.mapView.settings.scrollGestures = YES;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
   
}



-(void)plotPolyLines {
    NSInteger numberOfSteps = path.count;
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:self.sourceLoc.latitude longitude:self.sourceLoc.longitude];;
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [path objectAtIndex:index];
        GMSMutablePath *path1 = [GMSMutablePath path];
        [path1 addCoordinate:CLLocationCoordinate2DMake(location1.coordinate.latitude,location1.coordinate.longitude)];
        location1 = location;
        [path1 addCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)];
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path1];
        singleLine.strokeWidth = 4;
        singleLine.strokeColor = [UIColor blueColor];
        singleLine.map = self.mapView;
        
        
    }
}
-(void)placeMarkers
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    
    marker.position = CLLocationCoordinate2DMake(self.sourceLoc.latitude, self.sourceLoc.longitude);
    marker.title = self.source.text;
    marker.snippet = @"Source";
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    marker.opacity = 0.9;
    marker.map = self.mapView;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.sourceLoc.latitude  longitude:self.destinationLoc.longitude zoom:10];
    self.mapView.camera = camera;
    
    
    GMSMarker *marker2 = [[GMSMarker alloc]init];
    marker2.position = CLLocationCoordinate2DMake(self.destinationLoc.latitude, self.destinationLoc.longitude);
    marker2.title=self.destination.text;
    marker2.snippet =@"Destination";
    marker2.appearAnimation = kGMSMarkerAnimationPop;
    marker2.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    marker2.opacity = 0.9;
    marker2.map = self.mapView;
    
    
}

- (void)parseResponse:(NSDictionary *)response {
    NSArray *routes = [response objectForKey:@"routes"];
    NSDictionary *route = [routes lastObject];
    if (route) {
        NSString *overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
        path = [self decodePolyLine:overviewPolyline];
    }
}

-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
    
    return array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)destination:(id)sender {
}

//drwaing polyline
//    GMSMutablePath *path1 = [GMSMutablePath path];
//    [path1 addCoordinate:CLLocationCoordinate2DMake(@(28.446601).doubleValue,@(77.309195).doubleValue)];
//    [path1 addCoordinate:CLLocationCoordinate2DMake(@(28.572328).doubleValue,@(77.242311).doubleValue)];
//    GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path1];
//    singleLine.strokeWidth = 4;
//    singleLine.strokeColor = [UIColor blueColor];
//    singleLine.map = self.mapView;



// self.view = self.mapView;


//    NSString *urlString = [NSString stringWithFormat:
//                           @"%@?origin=%f,%f&destination=%f,%f.129566&sensor=true&key=%@",
//                           @"https://maps.googleapis.com/maps/api/directions/json",
//                           41.511217,
//                           -81.606697,
//                           41.5133020,
//                           -81.605268,
//                           @"AIzaSyDFImDqWrTV95djoaL7CoIYkyTAe3fbdu0"];
//    NSURL *directionsURL = [NSURL URLWithString:urlString];
//
//
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:directionsURL];
//    [request startSynchronous];
//    NSError *error = [request error];
//    if (!error) {
//        NSString *response = [request responseString];
//        NSLog(@"facebook.com/truqchal %@",response);
//        NSDictionary *json =[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
//        GMSPath *path =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
//        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
//        singleLine.strokeWidth = 7;
//        singleLine.strokeColor = [UIColor greenColor];
//        singleLine.map = self.mapView;
//    }
// Do any additional setup after loading the view, typically from a nib.



//    [HTTPClientUtil getDataFromWS:@"http://maps.googleapis.com/" WithHeaderDict:parameters withBlock:^(AFHTTPRequestOperation* response, NSError *error)
//     {
//         if (response)
//         {
//                       }
//             else
//             {
//              //   block(nil,response.response.statusCode);
//             }
//
//     }];
//


@end
