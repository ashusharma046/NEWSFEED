//
//  RootViewController.h
//  NewFeed
//
//  Created by Aneesh on 08/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITEM.h"
@class ITEM;
@interface RootViewController : UITableViewController<NSXMLParserDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate>  {
    
    NSXMLParser *parser;
    NSMutableString *currentStringValue;
    NSMutableString *currentTitle;
    NSMutableString *currentdesc;
    NSMutableArray *objArray;
    IBOutlet UIScrollView *scrollview;
    ITEM *item;
    
    
    //for search purpose
    NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;

}
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end
