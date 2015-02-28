/*
 * This testprogram creates a cost fundtion vector 
 * to maximize for estimating pitch by ANLS.
 * TODO: merge with the rest of pitch estimator
 */
#include <iostream>
#include <cmath>
#include <stdlib.h>
#include "smc_anls.h"
#include "smc_wavread.h"
#include <fftw3.h>

char inputFileName[] = "data/5.wav";
char outputFileName[] = "data/guitar_tuner1.txt";
char FFTOutputFileName[] = "data/fft.txt";
char costOutputFileName[] = "data/cost.txt";

float F0Res=0.5;
float F0Max=140.1, F0Min=72.1;
int L=5, Fs=44100;

int NFFT;

// FFT algorithm
float* smc_fft(float *fftInputBuffer, int NFFT, char* FFTOutputFileName)
{
    FILE *fp_open_r;
    FILE *fp_open_w;

    fftw_complex *in, *out;
    fftw_plan p;

    /* Allocate the input and output arrays, and create the plan */
    in  = ( fftw_complex* ) fftw_malloc(sizeof(fftw_complex) * NFFT);
    out = ( fftw_complex* ) fftw_malloc(sizeof(fftw_complex) * NFFT);
    p   = fftw_plan_dft_1d(NFFT, in, out, FFTW_FORWARD, FFTW_ESTIMATE);

    /* input array */
    int i;
    for (i = 0; i < NFFT; i++) {
        in[i][0] = fftInputBuffer[i];               /* Real part */
        in[i][1] = 0.0;                          /* Imaginary part */
    }

    /* Execute the plan on the input data */
    fftw_execute(p);

    /* Open file pointer writable */
    fp_open_w = fopen(FFTOutputFileName, "w");

    /* Print out the results to file*/
    float* X;
    X = (float *) malloc(NFFT*sizeof(float));
    float* FFTAxis;
    FFTAxis = (float*) malloc(round(NFFT/2)*sizeof(float));
    for (i = 0; i < round(NFFT/2); i++) {
        X[i] = (float)(sqrt((out[i][0])*(out[i][0]) + (out[i][1])*(out[i][1])));
        FFTAxis[i] = ((float)i)*Fs/NFFT;
        // printf("%f\n", X[i]);
        fprintf(fp_open_w, "%f \t %f\n", FFTAxis[i], X[i]);  
    }

    /* Clean up */
    return X;
    free(X);
        free(FFTAxis);
    fclose(fp_open_r);
    fclose(fp_open_w);
    fftw_destroy_plan(p);
    fftw_free(in); 
    fftw_free(out);
} 


void smc_write_file_float(float outputBuffer[], char *name, int N)
{
    FILE *outFile;
    int n;

    outFile=fopen(name, "w");
    if (outFile) {
        for(n=0; n < N; n++)
        fprintf(outFile, "%f\n", outputBuffer[n]);
        fclose(outFile);
    }
}

void smc_write_file_float_2columns(float* columnOne, float* columnTwo, char* name, int N)
{
    FILE *outFile;
    int n;

    outFile=fopen(name, "w");
    if (outFile) {
        for(n=0; n < N; n++)
        fprintf(outFile, "%f \t %f \n", columnOne[n], columnTwo[n]);
        fclose(outFile);
    }
}

int smc_arg_max(float* CostFunction,int size)
{
    float MaxVal=-32000;
    int argmax;
	for (int i = 0; i < size; i++)
	{
		if (MaxVal < CostFunction[i])
		    MaxVal = CostFunction[i];
            argmax = i;
	}
    return argmax;
}

int main()
{
    int F0AreaSize = round((F0Max-F0Min)/F0Res+1);
    // Memory Allocation
	float *F0Area;
    F0Area = (float *)malloc(F0AreaSize*sizeof(float));
	float *cost;
    cost = (float *)malloc(F0AreaSize*sizeof(float));

    // Read wav-file
    float* sig;
    sig = smc_wavread(inputFileName, outputFileName);

    // Make FFT
	int NFFT = 176400; //sig length (printed in terminal, if unknown)
    float *X;
    X = (float *)malloc(NFFT*sizeof(float));
    X = smc_fft(sig, NFFT,FFTOutputFileName);
    
    // Create Cost
    smc_generate_F0Area(F0Min, F0Max, F0Res, F0Area, F0AreaSize);
	smc_create_HS_cost(Fs, L, X, F0Area, cost, round(NFFT/2), F0AreaSize);
    smc_write_file_float_2columns(F0Area, cost, costOutputFileName, F0AreaSize);
    int argMax;
    argMax = smc_arg_max(cost, F0AreaSize);

    float pitchEstimate;
    pitchEstimate = F0Area[argMax];
    printf("\n\n pitchEstimate is: %f Hz\n", pitchEstimate);

    for (int i = 0; i < 20; i++)
    {
    	printf("%f\n", F0Area[i]);
    }
    // Maximize Cost funtion here

    
    free(X);
	free(cost);
return 0;
}
