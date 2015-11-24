//
//  MyBooksViewController.m
//  BarterApp
//
//  Created by ajay singh on 11/9/15.
//  Copyright © 2015 UB. All rights reserved.
//

#import "MyBooksViewController.h"
#import "CustomBookCell.h"

@interface MyBooksViewController ()  <UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyBooksViewController

NSMutableArray *dictobj;
NSMutableArray *booksArray;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    dictobj = [[NSMutableArray alloc]init];
    booksArray = [[NSMutableDictionary alloc]init];


    NSString *myIdentifier = @"BookCell";
    [self.myBooksTableView registerNib:[UINib nibWithNibName:@"CustomBookCell" bundle:nil] forCellReuseIdentifier:myIdentifier];

}

-(void)viewWillAppear:(BOOL)animated{

    self.myBooksTableView.delegate = self;
    self.myBooksTableView.dataSource =self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *userID = [prefs stringForKey:@"userID"];
    
    //header fields
    [manager.requestSerializer setValue:@"vTdpl8GYzaxIxbT5PF6WauKWyVLMXfv2f57WoNvV9H0" forHTTPHeaderField:@"X-CSRF-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *originalParameters = @{@"user_id":userID};
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/hal+json",@"text/json", @"text/javascript", @"text/html", nil];
    
    NSString *fullString = [NSString stringWithFormat:@"http://dev-my-barter-site.pantheon.io/myrestapi/books_backend/retrieve_user_books"];
    
    
    [manager POST:fullString parameters:originalParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"hello");
        NSLog(@"%@", responseObject) ;
        
        
        if ([NSJSONSerialization isValidJSONObject: responseObject]){
            NSLog(@"Good JSON \n");
        }
        
        
        NSError* error= nil;
        
        NSMutableArray *jsonArray = [NSMutableArray arrayWithArray:responseObject];
        NSString *json = [NSString stringWithFormat:@"%@" ,[jsonArray objectAtIndex:0]];
        
        NSData *objectData = [json dataUsingEncoding:NSUTF8StringEncoding];
        dictobj = [NSJSONSerialization JSONObjectWithData:objectData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
       
        
        [self.myBooksTableView reloadData];
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    
    
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [dictobj count];
    
}


//use custom book cell for books
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BookCell";
    CustomBookCell *cell = (CustomBookCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        cell = [[CustomBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
     }
    
    cell.BookTitle.text  = [[dictobj objectAtIndex:indexPath.row]objectForKey:@"title"];
    cell.BookAuthor.text = [[dictobj objectAtIndex:indexPath.row]objectForKey:@"book_author"];
    cell.yearOfPurchase.text = [[dictobj objectAtIndex:indexPath.row]objectForKey:@"book_year_of_purchase"];
    
    
    //cell. = [dictobj objectForKey:[keys objectAtIndex:indexPath.row]];

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}




- (IBAction)onuploadBtnPressed:(id)sender {
    [self performSegueWithIdentifier:@"Upload" sender:sender];
}
@end
