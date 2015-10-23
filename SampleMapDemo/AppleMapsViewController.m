//
//  AppleMapsViewController.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 22/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "AppleMapsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AFNetworking/AFNetworking.h>
@interface AppleMapsViewController () <MKMapViewDelegate>
{

}
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) NSMutableArray *path;
@end

@implementation AppleMapsViewController
@synthesize mapView = _mapView;
@synthesize path = _path;
- (void)viewDidLoad {
    [super viewDidLoad];
    _path = [[NSMutableArray alloc] init];
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    // Do any additional setup after loading the view from its nib.
    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(28.446601,77.309195), 2000, 2000);
//    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion]; [_mapView setRegion:adjustedRegion animated:NO];
    
    [self placeMarkers];
    
    AFHTTPClient *_httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://maps.googleapis.com/"]];
    [_httpClient registerHTTPOperationClass: [AFJSONRequestOperation class]];
    [_httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f", 28.446601, 77.309195] forKey:@"origin"];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f", 28.572328, 77.242311] forKey:@"destination"];
    [parameters setObject:@"true" forKey:@"sensor"];
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

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([[annotation title] isEqualToString:@"SRS Tower"]) {
        return nil;
    }
    
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    if ([[annotation title] isEqualToString:@"Kalkaji F-block"])
        annView.image = [ UIImage imageNamed:@"taxi.png" ];
//        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [infoButton addTarget:self action:@selector(showDetailsView)
//         forControlEvents:UIControlEventTouchUpInside];
//    annView.rightCalloutAccessoryView = infoButton;
//    annView.canShowCallout = YES;
    return annView;
}

-(void)placeMarkers
{
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(28.446601, 77.309195);
    annotation.title = @"SRS Tower";
    annotation.subtitle = @"Faridabad";
    [self.mapView addAnnotation:annotation];
    
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc] init];
    annotation1.coordinate = CLLocationCoordinate2DMake(28.572328, 77.242311);
    annotation1.title = @"Kalkaji F-block";
    annotation1.subtitle = @"Delhi";
    [self.mapView addAnnotation:annotation1];
    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    
//    marker.position = CLLocationCoordinate2DMake(28.446601, 77.309195);
//    marker.title = @"Faridabad SRS tower";
//    marker.snippet = @"Source";
//    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
//    marker.opacity = 0.9;
//    marker.map = self.mapView;
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:28.446601  longitude:77.309195 zoom:10];
//    self.mapView.camera = camera;
//    
//    
//    GMSMarker *marker2 = [[GMSMarker alloc]init];
//    marker2.position = CLLocationCoordinate2DMake(28.572328, 77.242311);
//    marker2.title=@"Kalkaji F-block";
//    marker2.snippet =@"Destination";
//    marker2.appearAnimation = kGMSMarkerAnimationPop;
//    marker2.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
//    marker2.opacity = 0.9;
//    marker2.map = self.mapView;
    
    //drwaing polyline
    //    GMSMutablePath *path1 = [GMSMutablePath path];
    //    [path1 addCoordinate:CLLocationCoordinate2DMake(@(28.446601).doubleValue,@(77.309195).doubleValue)];
    //    [path1 addCoordinate:CLLocationCoordinate2DMake(@(28.572328).doubleValue,@(77.242311).doubleValue)];
    //    GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path1];
    //    singleLine.strokeWidth = 4;
    //    singleLine.strokeColor = [UIColor blueColor];
    //    singleLine.map = self.mapView;
    
    
}


-(void)plotPolyLines {
    NSInteger numberOfSteps = _path.count;
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [_path objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        coordinates[index] = coordinate;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [_mapView addOverlay:polyLine];
}

- (void)parseResponse:(NSDictionary *)response {
    NSArray *routes = [response objectForKey:@"routes"];
    NSDictionary *route = [routes lastObject];
    if (route) {
        NSString *overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
        _path = [self decodePolyLine:overviewPolyline];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineWidth = 2.0;
    
    return polylineView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
