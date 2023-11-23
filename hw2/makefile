copystr:
	aarch64-linux-gnu-as copystr.s -o copystr.o
	aarch64-linux-gnu-as copystr_data.s -o copystr_data.o
	aarch64-linux-gnu-ld copystr.o copystr_data.o -o copystr

atoi:
	aarch64-linux-gnu-as atoi.s -o atoi.o
	aarch64-linux-gnu-as atoi_data.s -o atoi_data.o
	aarch64-linux-gnu-ld atoi.o atoi_data.o -o atoi

bins:
	aarch64-linux-gnu-as bins.s -o bins.o
	aarch64-linux-gnu-as bins_data.s -o bins_data.o
	aarch64-linux-gnu-ld bins.o bins_data.o -o bins

all: copystr atoi

clean:
	rm -f *.o copystr atoi bins
