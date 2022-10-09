
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

#define BUF_MAX 2 * 1024
#define INC 512

int flush_frac(){
	printf("IN_DRAM, IN_CACHE, ns_TO_FLUSH, cycles_TO_FLUSH\n" );
	int iter=10;
	long_long s_cycle, e_cycle;
	long_long s_nano, e_nano;
	long_long nsec_avg, cycle_avg;

	for (int i=0; i<=BUF_MAX; i+=INC){
		/* microsecs and cycles */
		nsec_avg=0;
		cycle_avg=0;

		for (int k=0; k<iter; k++){
			/* allocate buffer -- it starts in the cache */
			char * buf = (char *) malloc( BUF_MAX );

			/*preflush the beginning i bytes of the buffer */
			for ( int j=0; j<i; j+=64 ){
				_mm_clflush( buf + j );
			}

			/* measure time to flush now that some are flushed */
			s_cycle = PAPI_get_real_cyc();
			s_nano = PAPI_get_real_nsec();
			for (int j=0; j<BUF_MAX; j+=64){
				_mm_clflush(buf + j);
			}
			e_nano = PAPI_get_real_nsec();
			e_cycle = PAPI_get_real_cyc();
			cycle_avg+=(e_cycle - s_cycle);
			nsec_avg+=(e_nano - s_nano);
		}
		printf("%d, %d, %lld, %lld\n", i, BUF_MAX-i, nsec_avg/iter, cycle_avg/iter);
	}
	return 0;
}

int main(){


	flush_frac();
	return 0;

	printf("in_cache_buffer_size, num_cycles_spent_flushing, ns_spent_flushing\n" );
	for (int i=1; i<=BUF_MAX; i=i*2){

		/* allocate buffer -- it starts in the cache */
		char * buf = (char *) malloc( i );
		/* microsecs and cycles */
		long_long nsec_avg=0;
		long_long cycle_avg=0;
		for ( int k=0; k < 10; k++ ){
			long_long s_cycle = PAPI_get_real_cyc();
			long_long s_nano = PAPI_get_real_nsec();
			int j;
			for (j =0; j < i; j+=64){
				_mm_clflush( buf + j );
			}
			//_mm_clflush( buf + (j + 64) );

			long_long e_nano = PAPI_get_real_nsec();
			long_long e_cycle = PAPI_get_real_cyc();;

			cycle_avg+=(e_cycle - s_cycle);
			nsec_avg+=(e_nano - s_nano);
		}
		/* start timer */
		printf("%d, %lld, %lld\n", i, cycle_avg/10, nsec_avg/10 );
	}


}
