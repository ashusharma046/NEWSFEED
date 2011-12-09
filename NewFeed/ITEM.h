//
//  ITEM.h
//  RssFeeds
//
//  Created by Aneesh on 06/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ITEM : NSObject {
    NSString *title;
    NSString *desc;
    NSString *link;
    NSString *media;
    
}
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,retain) NSString *link;
@property(nonatomic,retain) NSString *media;

@end
