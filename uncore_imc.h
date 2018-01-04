#ifndef uncore_imc_h
#define uncore_imc_h

#define _GNU_SOURCE
#include <assert.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include "perf_utils.h"

#define NMC 4
#define NEDC 0
#define MC_FLAG_READ 0
#define MC_FLAG_WRITE 1
#define EDC_FLAG_READ 2
#define EDC_FLAG_WRITE 3

struct counters
{
    uint64_t mc_rd[NMC];
    uint64_t mc_wr[NMC];
    uint64_t edc_rd[NEDC];
    uint64_t edc_wr[NEDC];
};

void setup();
uint64_t readctr(int flag, int ctr);

static void readcounters(struct counters *s)
{
    for (int i = 0; i < NMC; ++i)
    {
        s->mc_rd[i] = readctr(MC_FLAG_READ, i);
        s->mc_wr[i] = readctr(MC_FLAG_WRITE, i);
    }
    for (int i = 0; i < NEDC; ++i)
    {
        s->edc_rd[i] = readctr(EDC_FLAG_READ, i);
        s->edc_wr[i] = readctr(EDC_FLAG_WRITE, i);
    }
}

#endif //uncore_imc_h
