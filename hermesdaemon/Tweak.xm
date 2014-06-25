#import <xpc/xpc.h>
#import <xpc/connection.h>
#include <mach/mach.h>
#include <libkern/OSCacheControl.h>
#include <stdbool.h>
#include <dlfcn.h>
#include <sys/sysctl.h>

inline int PIDForProcessNamed(NSString *passedInProcessName) {
    // Thanks to http://stackoverflow.com/questions/6610705/how-to-get-process-id-in-iphone-or-ipad
    // Faster than ps,grep,etc
    //Thanks to Adam Bell for being awesome!
    //If anyone reads these comments...seriously, why are you here? Message me, lets talk...im lonely ;_;

    int pid = 0;

    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;

    size_t size;
    int st = sysctl(mib, (u_int)miblen, NULL, &size, NULL, 0);

    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;

    do {

        size += size / 10;
        newprocess = (kinfo_proc *)realloc(process, size);

        if (!newprocess) {
            if (process) {
                free(process);
            }
            return 0;
        }

        process = newprocess;
        st = sysctl(mib, (u_int)miblen, process, &size, NULL, 0);

    } while (st == -1 && errno == ENOMEM);

    if (st == 0) {

        if (size % sizeof(struct kinfo_proc) == 0) {
            int nprocess = (int)(size / sizeof(struct kinfo_proc));

            if (nprocess) {
                for (int i = nprocess - 1; i >= 0; i--) {
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];

                    if ([processName rangeOfString:passedInProcessName].location != NSNotFound) {
                        pid = process[i].kp_proc.p_pid;
                    }
                }

                free(process);
            }
        }
    }
    if (pid == 0) {
        NSLog(@"[Hermes3] GET PROCESS %@ FAILED.", [passedInProcessName uppercaseString]);
    }

    return pid;
}

static int (*orig_XPConnectionHasEntitlement)(xpc_connection_t connection, NSString *entitlement);

static int hermes_XPConnectionHasEntitlement(xpc_connection_t connection, NSString *entitlement) {
    //Only grant the required entitlement
    if (xpc_connection_get_pid(connection) == PIDForProcessNamed(@"SpringBoard") && [entitlement isEqualToString:@"com.apple.multitasking.unlimitedassertions"]) {
        return true;
    }

    return orig_XPConnectionHasEntitlement(connection, entitlement);
}

