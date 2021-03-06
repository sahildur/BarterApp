//
//  RegisterViewController.m
//  BarterApp
//
//  Created by ajay singh on 11/19/15.
//  Copyright © 2015 UB. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"


@interface RegisterViewController () <UITextFieldDelegate>

@end

@implementation RegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
}



-(void)viewWillAppear:(BOOL)animated{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; //  return 0;
    return [emailTest evaluateWithObject:candidate];
}



-(BOOL) checkAllTheParameters{
    //check for valid email
    if (![self validateEmail:[self.emailID text]]) {
        [self showAlertView:@"Not a valid email ID" and:@"OK"];
        return false;
    }
    
    // check if two pass word are matching
    if ([self.password.text isEqualToString:self.confirmPassword.text])
    {
        return true;
    }
    else
    {
        [self showAlertView:@"password donot match" and:@"OK"];
        return false;
    }
    return true;
}



- (IBAction)onRegisterButtonPressed:(id)sender {
    if (![self checkAllTheParameters]) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //header fields
    [manager.requestSerializer setValue:@"vTdpl8GYzaxIxbT5PF6WauKWyVLMXfv2f57WoNvV9H0" forHTTPHeaderField:@"X-CSRF-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *originalParameters = @{@"email":[self.emailID text] ,@"pass":[self.password text], @"firstName": [self.firstName text] ,@"lastName": [self.lastName text]};

    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/hal+json",@"text/json", @"text/javascript", @"text/html", nil];
    
    NSString *fullString = [NSString stringWithFormat:@"http://dev-my-barter-site.pantheon.io/myrestapi/barter_user_service"];
    
    
    [manager POST:fullString parameters:originalParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"hello");
        NSLog(@"%@", responseObject);
        
        NSError* error= nil;
        
        NSMutableArray *jsonArray = [NSMutableArray arrayWithArray:responseObject];
        NSString *json = [NSString stringWithFormat:@"%@" ,[jsonArray objectAtIndex:0]];
        
        NSData *objectData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonD = [NSJSONSerialization JSONObjectWithData:objectData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:[NSString stringWithFormat:@"Successfully registered"]
                                      message:@""
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        [[self navigationController] popViewControllerAnimated:YES];

                                        //Handel your yes please button action here
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}



-(void) showAlertView: (NSString *) Title and:(NSString *) information{
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:Title
                                  message:@""
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:information
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                
                                    
                                    //Handel your yes please button action here
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];

}


-(NSString *) GetJsonData :(id) Object String:(NSString *) value {
    NSError *error = nil;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:Object options:NSJSONReadingMutableLeaves error: &error];

    return @"hello";

}


-(void)dismissKeyboard {
    [self.emailID resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}


@end
