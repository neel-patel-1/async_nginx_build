#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <getopt.h>
#include <limits.h>
#include <assert.h>
#include <dirent.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <utime.h>
#include <sys/ioctl.h>
#include <linux/fs.h>
#include <errno.h>
#include <fcntl.h>
#include <papi.h>

int main(){
	int size = 16384;
	char * buf=malloc(size);
	long_long s_nsec, e_nsec;
	s_nsec= PAPI_get_real_nsec();
	long long int t;
	long long int * iter=(long long int * ) (buf + size );
	while ( iter < (long long int * ) (buf + size ))
	{
		t = *( long long int *) iter;

	}

	e_nsec= PAPI_get_real_nsec();

}
