//
//  PolygonSprite.m
//  CutCutCut
//
//  Created by 河野 洋志 on 2012/09/11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "PolygonSprite.h"


@implementation PolygonSprite
@synchronized body = _body;
@synchronized original = _original;
@synchronized centroid = _centroid;

+ (id)spriteWithFile:(NSString *)filename body:(b2Body *)body original:(BOOL)original
{
    return [[self alloc] initWithFile:filename body:body original:original];
}

+ (id)spriteWithTexture:(CCTexture2D *)texture body:(b2Body *)body original:(BOOL)original
{
    return [[self alloc] initWithTexture:texture body:body original:original];
}

+ (id)spriteWithWorld:(b2World *)world
{
    return [[self alloc] initWithWorld:world];
}

- (id)initWithFile:(NSString *)filename body:(b2Body *)body original:(BOOL)original
{
    NSAssert(filename != nil, @"Invalid filename for sprite");
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: filename];
    return [self initWithTexture:texture body:body original:original];
}

- (id)initWithTexture:(CCTexture2D *)texture body:(b2Body *)body original:(BOOL)original
{
    b2Fixture *originalFixture = body->GetFixtureList();
    b2PolygonShape *shape = (b2PolygonShape *)originalFixture->GetShape();
    int vertexCount = shape->GetVertexCount();
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:vertexCount];
    for (int i = 0; i < vertexCount; i++) {
        CGPoint p = ccp(shape->GetVertex(i).x * PTM_RATIO, shape->GetVertex(i).y * PTM_RATIO);
        [points addObject:[NSValue valueWithCGPoint:p]];
    }
    
    if ((self = [super initWithPoints:points andTexture:texture])) {
        _body = body;
        _body->SetUserData(self);
        _original = original;
        _centroid = self.body->GetLocalCenter();
    
        self.anchorPoint = ccp(_centroid.x * PTM_RATIO / texture.contentSize.width,
                               _centroid.y * PTM_RATIO / texture.contentSize.height);
    }
    return self;
}
- (id)initWithWorld:(b2World *)world
{
    return nil;
}

- (b2Body *)createBodyFroWorld:(b2World *)world position:(b2Vec2)position rotation:(float)rotation vertices:(b2Vec2 *)vertices vertexCount:(int32)count density:(float)density friction:(float)friction restitution:(float)restitution;
- (void)activateCollisions;
- (void)deactivateCollisions;

@end
