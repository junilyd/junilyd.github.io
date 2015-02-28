/*
 * This testprogram creates a cost fundtion vector 
 * to maximize for estimating pitch by ANLS.
 * TODO: write the last part in to function/functions
 */

#ifndef NUMELEMENTS
	#define NUMELEMENTS(x)  (sizeof(x) / sizeof(x[0]))
#endif

/**
 * Create vector containg the frequency search area.
 * @param F0Min Minimum frequency (Hz) of search area.
 * @param F0Max Maximum frequency (Hz) of search area.
 * @param F0Res Frequency resoltion in Hertz.
 * @param *F0Area Pointer to search area (for output).
 * @param F0AreaSize Length of vector F0Area.
 */
void smc_generate_F0Area(float F0Min, float F0Max, float F0Res, float* F0Area, int F0AreaSize);
/**
 * Create vector containg the frequency search area.
 * @param Fs Sample Rate
 * @param L Number of harmonic partials to use.
 * @param *receivedX Pointer to FFT-vector.
 * @param *F0Area Pointer to search area.
 * @param *cost Pointer to cost function (for output).
 * @param NFFT Length of FFT-vector (assumed to be cut at Nyquist=Fs/2)
 * @param F0AreaSize Length of F0Area (search area)
 */
 void smc_create_HS_cost(int Fs, int L, float* X, float* F0Area, float* cost, int NFFT, int F0AreaSize);