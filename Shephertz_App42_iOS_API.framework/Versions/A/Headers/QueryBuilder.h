
/***********************************************************************
 *
 * QueryBuilder.h
 * PAE_iOS_SDK
 * Created by shephertz technologies on 23/04/13.
 * Copyright (c) 2013 ShephertzTechnology PVT LTD. All rights reserved.
 *
 ***********************************************************************/


#import <Foundation/Foundation.h>
#import "Query.h"
@interface QueryBuilder : NSObject

/**
 * @param key
 * @param Value
 * @param op
 * @return Query object
 * @throws JSONException
 */

+(Query*)buildQueryWithKey:(NSString*)key value:(id)value operator:(NSString*)op;

/**
 * @param q1
 * @param q2
 * @param op
 * @return Query object
 */
+(Query*)combineQuery:(Query*)q1 withQuery:(Query*)q2 usingOperator:(NSString*)op;

@end
