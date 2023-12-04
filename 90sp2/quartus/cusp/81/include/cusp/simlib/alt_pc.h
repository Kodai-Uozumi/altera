
#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_PC_H
#define __ALT_PC_H
 
template <int PC_WIDTH=-1, int PC_NUM_WORDS=-1, int LATENCY=3> 
class ALT_PC : public ALT_CUSP_SYNTH::FU
{
public:
private:
// Private methods added to ensure that our test script that checks 
// methods are available in hardware and software passes
    void goto_if();
	void hold();
	void halt();
	void call();

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_pc");

#endif
