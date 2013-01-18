//
//  LLog.h
//  Catpcha
//
//  Created by Mason on 11/26/12.
//  Copyright (c) 2012 CasualLama. All rights reserved.
//

#ifndef Catpcha_LLog_h
#define Catpcha_LLog_h

#define alog(fmt, ...) NSLog(@"%s [%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define plog(fmt, ...) NSLog(@"" fmt, ##__VA_ARGS__);

//#define tlog(fmt, ...) TFLog(@"%s [%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define tlog(fmt, ...) NSLog(@"%s [%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifdef DEBUG
#	define dlog(fmt, ...) alog(fmt, ##__VA_ARGS__);
#   define vlog(fmt, ...) alog(fmt, ##__VA_ARGS__);
#   define wlog(fmt, ...) alog(fmt, ##__VA_ARGS__);
#   define elog(err)      if(err) alog(@"[ERROR] %@", err);

#   define ulog(fmt, ...) \
UIAlertView* alert = [[UIAlertView alloc] \
initWithTitle:[NSString stringWithFormat:@"%s\n [line %d] ", __PRETTY_FUNCTION__, __LINE__] \
message:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
delegate:nil \
cancelButtonTitle:@"Ok" \
otherButtonTitles:nil]; \
[alert show]; \

#else
#   define vlog(fmt, ...) tlog(fmt, ##__VA_ARGS__);
#   define wlog(fmt, ...) tlog(fmt, ##__VA_ARGS__);
#   define elog(err)      tlog(@"[ERROR] %@", err);
#   define dlog(fmt, ...) tlog(fmt, ##__VA_ARGS__);
#   define ulog(fmt, ...) tlog(fmt, ##__VA_ARGS__);
#endif

#define dlogln      dlog(@"*");

#define dlogobjn(o)   dlog(#o @"=\n%@", o);
#define dlogobj(o)   dlog(#o @"=%@", o);
#define dlogptr(p)   dlog(#p @"=%p", p);
#define dlogint(i)   dlog(#i @"=%d", i);
#define dlogfloat(f) dlog(#f @"=%f", f);

#define dlogrect(r)  dlog(#r @"={{x:%.1f,y:%.1f},{w:%.1f,h:%.1f}}", r.origin.x, r.origin.y, r.size.width, r.size.height);
#define dlogsize(s)  dlog(#s @"={w:%.1f,h:%.1f}", s.width, s.height);
#define dlogpoint(p) dlog(#p @"={x:%.1f,y:%.1f}", p.x, p.y);
#define dlogline(l)  dlog(#l @"={{x:%.1f,y:%.1f} -> {x:%.1f,y:%.1f}", l.from.x, l.from.y, l.to.x, l.to.y);

#define dlogmoment(m) dlog(#m @"={%.2f v:%.2f a:%.2f}", m.value, m.velocity, m.acceleration);
#define dlogvector(v) dlog(#v @"={%.2f,%.2f}", v.x.value, v.y.value);
#define dlogcolor(c) dlog(#c @"={r:%.1f, g:%.1f, b:%.1f, a:%.1f}", c.r.value, c.g.value, c.b.value, c.a.value);

#define dlogxvector(v) dlog(#v @"={x:%.2f (%.2f/%.2f), y:%.2f (%.2f/%.2f)}", v.x.value, v.x.velocity, v.x.acceleration, v.y.value, v.y.velocity, v.y.acceleration);
#define dlogxcolor(c) dlog(#c @"={r:%.1f (%.1f/%.1f), g:%.1f (%.1f/%.1f), b:%.1f (%.1f/%.1f), a:%.1f (%.1f/%.1f)}", c.r.value, c.r.velocity, c.r.acceleration,c.g.value, c.g.velocity, c.g.acceleration, c.b.value, c.b.velocity, c.b.acceleration, c.a.value, c.a.velocity, c.a.acceleration);

#define plogobjn(o)  plog(@"[" #o @"] : \n%@", o);
#define plogobj(o)   plog(@"[" #o @"] : %@", o);
#define plogptr(p)   plog(@"[" #p @"] : %p", p);
#define plogint(i)   plog(@"[" #i @"] : %d", i);
#define plogfloat(f) plog(@"[" #f @"] : %f", f);

#define plogrect(r)  plog(@"[" #r @"] : {{x:%.1f, y:%.1f},{w:%.1f, h:%.1f}}", r.origin.x, r.origin.y, r.size.width, r.size.height);
#define plogsize(s)  plog(@"[" #s @"] : {w:%.1f, h:%.1f}", s.width, s.height);
#define plogpoint(p) plog(@"[" #p @"] : {x:%.1f, y:%.1f}", p.x, p.y);
#define plogline(l)  plog(@"[" #l @"] : {{x:%.1f, y:%.1f} -> {x:%.1f, y:%.1f}", l.from.x, l.from.y, l.to.x, l.to.y);

#define plogmoment(m) plog(@"[" #m @"] : {%.2f v:%.2f a:%.2f}", m.value, m.velocity, m.acceleration);
#define plogvector(v) plog(@"[" #v @"] : {%.2f, %.2f}", v.x.value, v.y.value);
#define plogcolor(c)  plog(@"[" #c @"] : {r:%.1f, g:%.1f, b:%.1f, a:%.1f}", c.r.value, c.g.value, c.b.value, c.a.value);

#define plogxvector(v) plog(@"[" #v @"] : {x:%.2f (%.2f/%.2f), y:%.2f (%.2f/%.2f)}", v.x.value, v.x.velocity, v.x.acceleration, v.y.value, v.y.velocity, v.y.acceleration);
#define plogxcolor(c)  plog(@"[" #c @"] : {r:%.1f (%.1f/%.1f), g:%.1f (%.1f/%.1f), b:%.1f (%.1f/%.1f), a:%.1f (%.1f/%.1f)}", c.r.value, c.r.velocity, c.r.acceleration,c.g.value, c.g.velocity, c.g.acceleration, c.b.value, c.b.velocity, c.b.acceleration, c.a.value, c.a.velocity, c.a.acceleration);


#endif
