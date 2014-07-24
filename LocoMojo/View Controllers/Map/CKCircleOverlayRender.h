//
//  CKCircleOverlayView.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CKCircleOverlayRender : MKOverlayRenderer

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end
