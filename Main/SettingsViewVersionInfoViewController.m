//
//  SettingsViewVersionInfoViewController.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 9. 18..
//  Copyright (c) 2011년 KAIST. All rights reserved.
//

#import "SettingsViewVersionInfoViewController.h"
#import "SettingsViewCellController.h"
#import "NetworkHandler.h"
#import "SBJsonParser.h"

@implementation SettingsViewVersionInfoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NetworkHandler *networkHandler= [NetworkHandler getNetworkHandler];
    [networkHandler grabURLInBackground:@"grep/version/" callObject:self requestDict:nil method:@"GET" alert:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomID";
    SettingsViewCellController* cell=(SettingsViewCellController *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"SettingsViewCell" owner:self options:nil];
        cell=(SettingsViewCellController *)[nib objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    if(indexPath.row==0)
    {
        cell.title.text=@"최신버전";
        cell.desc.text=NewVersion;
        if(NewVersion!=nil&&[NewVersion floatValue]!=[[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"]floatValue])
        {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled=YES;
        }
    }
    else if(indexPath.row==1)
    {
        cell.title.text=@"현재버전";
        cell.desc.text=[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"];
    }
    
    // Configure the cell...
    
    return cell;
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString =[request responseString];
    //NSLog(responseString);
    SBJsonParser* json = [SBJsonParser alloc];
	NSDictionary *dataString = [json objectWithString:responseString];
    int errorcode = [[dataString objectForKey:@"errorcode"]intValue];
    
    [json release]; 
    if(errorcode==1300)
    {
        NewVersion=[[NSString alloc]initWithString:[dataString objectForKey:@"version"]];
    }
    
    [self.tableView reloadData];
}
    

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    if(indexPath.row==0)
    {
        NSString *AppStoreAddress = @"http://itunes.apple.com/us/app/id457294554?l=ko&ls=1&mt=8#";
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreAddress]];

    }
}

@end
