
/* Standard Includes */
#include <stdio.h>
#include <string.h>

/* Cache flush includes */
#include <x86intrin.h>

/* Char Device Offload Open includes */
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>

#include <time.h>

#include <papi.h>

#define BUF_MAX 16 * 1024 * 1024 

int main(){

	/* allocate buffer -- it starts in the cache */


	printf("in_cache_buffer_size, ratio_of_buffer_in_cache, num_cycles_spent_flushing, ns_spent_flushing\n" );
	for (int i=1; i<=BUF_MAX; i=i*2){
		/* microsecs and cycles */

		char * buf = (char *) malloc( i );
		long_long nsec_avg=0;
		long_long cycle_avg=0;
		for ( int k=0; k < 10; k++ ){
			long_long s_cycle = PAPI_get_real_cyc();
			long_long s_nano = PAPI_get_real_nsec();
			int j;
			for (j =0; j < i; j+=64){
				_mm_clflush( buf + j );
			}
			//_mm_clflush( buf + (j * 64) );

			long_long e_nano = PAPI_get_real_nsec();
			long_long e_cycle = PAPI_get_real_cyc();;

			cycle_avg+=(e_cycle - s_cycle);
			nsec_avg+=(e_nano - s_nano);
		}
		/* start timer */
		printf("%d, %lld, %lld\n", i, cycle_avg/10, nsec_avg/10 );
	}


}
