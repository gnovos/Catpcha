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

#define dlogline      dlog(@"*");

#define dlogobjn(o)   dlog(#o @"=\n%@", o);
#define dlogobj(o)   dlog(#o @"=%@", o);
#define dlogptr(p)   dlog(#p @"=%p", p);
#define dlogint(i)   dlog(#i @"=%d", i);
#define dlogfloat(f) dlog(#f @"=%f", f);

#define dlogrect(r)  dlog(#r @"={{%f,%f},{%f,%f}}", r.origin.x, r.origin.y, r.size.width, r.size.height);
#define dlogsize(s)  dlog(#s @"={%f,%f}", s.width, s.height);
#define dlogpoint(p) dlog(#p @"={%f,%f}", p.x, p.y);

#define dlogmoment(m) dlog(#m @"={%f v:%f a:%f}", m.value, m.velocity, m.acceleration);
#define dlogvector(v) dlog(#v @"={%f,%f}", v.x.value, v.y.value);
#define dlogcolor(c) dlog(#c @"={r:%f, g:%f, b:%f, a:%f}", c.r.value, c.g.value, c.b.value, c.a.value);

#define dlogxvector(v) dlog(#v @"={x:%f (%f/%f), y:%f (%f/%f)}", v.x.value, v.x.velocity, v.x.acceleration, v.y.value, v.y.velocity, v.y.acceleration);
#define dlogxcolor(c) dlog(#c @"={r:%f (%f/%f), g:%f (%f/%f), b:%f (%f/%f), a:%f (%f/%f)}", c.r.value, c.r.velocity, c.r.acceleration,c.g.value, c.g.velocity, c.g.acceleration, c.b.value, c.b.velocity, c.b.acceleration, c.a.value, c.a.velocity, c.a.acceleration);


#endif
