#include "ArrayList.h"

/**
 * Constructor for ArrayList
 * @param size Size of the array
 */
ArrayList::ArrayList(u_int64_t size) {
	dataarr = new int[size];
	for (u_int64_t i = 0; i < size; i++) {
		dataarr[i] = rand() % 100;
	}
	len = size;
}

/**
 * Destructor for ArrayList
 */
ArrayList::~ArrayList() {
	delete[] dataarr;
}

/**
 * Iterate through the array
 * @param i Index to start at
 */
void ArrayList::iterate_arr(u_int64_t i) {
	while (i < len) {
		int num = dataarr[i];
		i++;
	}
}
