#ifndef __OPTIMIZE__

#define NSLog(...) NSLog(__VA_ARGS__)

#else

#define NSLog(...) {}

#endif


#ifndef __OPTIMIZE__

#define DLog(...) NSLog(__VA_ARGS__)

#else

#define DLog(...) /* */

#endif


#define ALog(...) NSLog(__VA_ARGS__)