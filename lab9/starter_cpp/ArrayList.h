#include <cstdlib>
#include <unistd.h>

class ArrayList {
public:
	u_int64_t len;
	int* dataarr;

	ArrayList(u_int64_t size);
	~ArrayList();
	void iterate_arr(u_int64_t i);
};
