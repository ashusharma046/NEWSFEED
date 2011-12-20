//
//  RootViewController.m
//  NewFeed
//
//  Created by Aneesh on 08/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ITEM.h"
#import "DetailViewController.h"
#import "NewFeedAppDelegate.h"
@implementation RootViewController
@synthesize filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url=[NSURL URLWithString:@"http://feeds.nytimes.com/nyt/rss/HomePage"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    objArray=[[NSMutableArray alloc] init];
    
    parser= [[NSXMLParser alloc] initWithData:response];
    parser.delegate=self;
    [parser parse];
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[objArray count]];
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
    int i;
    for(i=0;i<[objArray count];i++){
        ITEM *item1=[objArray objectAtIndex:i];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"Images"];
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:savedImagePath]){
            [fileManager createDirectoryAtPath:savedImagePath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        NSURL *url = [NSURL URLWithString:item1.media];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *imageName = [NSString stringWithFormat:@"Image_%d.jpeg",i];
        
        NSLog(@"image ---------name is %@",imageName);
        
        
        
        
        
        if(imageData){
            NSString *getImagePath = [savedImagePath stringByAppendingPathComponent:imageName];
         
            [fileManager createFileAtPath:getImagePath contents:imageData attributes:nil]; 
        }
        
        

        
    }
    
    
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
    self.title=@"RSS FEEDS";
  }
    

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

 -(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
        if(!currentStringValue){
            currentStringValue = [[NSMutableString alloc] init];
        }   
       
        [currentStringValue setString:elementName];
        if([elementName isEqualToString:@"item"])
        { 
            if(!item){   
                item=[[ITEM alloc] init];
                if(!currentdesc){
                    currentdesc=[[NSMutableString alloc] init];
                    currentTitle=[[NSMutableString alloc] init];
                }
                
            }   
            
        }
        if([elementName isEqualToString:@"media:content"]){
            item.media=[attributeDict objectForKey:@"url"];
            
                       
}
} 
    
 -(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
        if([currentStringValue isEqualToString:@"title"])
        {   
            [currentTitle appendString:string];
            item.title=currentTitle;
           
            
        }
        if([currentStringValue isEqualToString:@"description"])
        {
            [currentdesc appendString:string];
            item.desc=currentdesc;
            
        }  
        if([currentStringValue isEqualToString:@"link"])
        {
            item.link=string;
           
        }  
        
        if([currentStringValue isEqualToString:@"media:content"])
        {
            item.media=string;
            
                  }  
        
        
}
    
 -(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
        //NSLog(@"did end elemnt --%@",elementName);
        if([elementName isEqualToString:@"item"])
        {
            [objArray addObject:item];
            item=nil;
            currentdesc=nil;
        } 
        
        currentStringValue=nil;
        
        
    }
    -(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
    {
        NSLog(@"CDATA:is %@", CDATABlock);
    }
    
/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [objArray count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ITEM *it;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        it = [self.filteredListContent objectAtIndex:indexPath.row];
      
    }
	else
	{
        it = [objArray objectAtIndex:indexPath.row];
    }

    cell.textLabel.text=it.title;
    NSURL *url = [NSURL URLWithString:it.media];
   
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
       
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"Images"];
    NSString *imageName = [NSString stringWithFormat:@"Image_%d.jpeg",indexPath.row];
     
    NSString *getImagePath = [savedImagePath stringByAppendingPathComponent:imageName];
    NSLog(@"celll image is %@",getImagePath);
    cell.imageView.image=[UIImage imageWithContentsOfFile:getImagePath];
  
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
    for (ITEM *it in objArray)
	{
		
			NSComparisonResult result = [it.title compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:it];
            }
		
	}
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    

    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
   [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITEM *it;
    
   
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        it = [self.filteredListContent objectAtIndex:indexPath.row];
        
    }
	else
	{
        it = [objArray objectAtIndex:indexPath.row];
    }

    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailViewController.content=it.desc;
    detailViewController.link=it.link;
    detailViewController.media=it.media;
    detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    detailViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:detailViewController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	self.filteredListContent = nil;
}





- (void)dealloc
{
    [super dealloc];
}

@end
