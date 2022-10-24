CXX=gcc

LIBS = -lpapi

.PHONY: clean 


a_lat: main.o Makefile 
	$(CXX) -o $@ main.c  $(LIBS) $(LDFLAGS)

clean:
	@rm -rf qat_page_comp *.o
