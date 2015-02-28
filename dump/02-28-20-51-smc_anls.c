#include <stdio.h>
#include <stdlib.h>
#include <math.h>
// #include "smc_anls.h"

void smc_generate_F0Area(float F0Min, float F0Max, float F0Res, float* F0Area, int F0AreaSize)
{
    *F0Area = 0;
    F0Area[0] = F0Min;
    for (int i = 1; i < F0AreaSize; i++) {
    	F0Area[i] = (float)F0Area[i-1] + (float)F0Res;
    }
}

void smc_create_HS_cost(int Fs, int L, float *X, float *F0Area, float *cost, int NFFT, int F0AreaSize) {
    
    int fIndex;     // One sample of F0Area
    for (int n = 0; n < F0AreaSize; n++)
    {
	    fIndex = (int)round(F0Area[n]*(2.f*NFFT/Fs)+1);
	    cost[n] = X[fIndex];
	    // Harmonic Summation
	    for (int l = 2; l <= L; l++)
	    {
	    	fIndex = (int)round(F0Area[n]*l*(2.f*NFFT/Fs)+1);
	    	cost[n] += X[fIndex];
	    }
	    // printf("%f\n", cost[n]);
    }    
    free(F0Area);
}