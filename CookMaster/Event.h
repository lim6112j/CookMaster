//
//  Event.h
//  CookMaster
//
//  Created by lim byeong cheol on 11. 11. 15..
//  Copyright (c) 2011년 ZenCom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * recipeName;
@property (nonatomic, retain) NSString * recipeDetail;
@property (nonatomic, retain) NSData * recipeImage;
@property (nonatomic, retain) NSString *recipeIconName;
@property (nonatomic, retain) NSString *ingredientName;
@property (nonatomic, retain) NSString *ingredientCheck;
@end
