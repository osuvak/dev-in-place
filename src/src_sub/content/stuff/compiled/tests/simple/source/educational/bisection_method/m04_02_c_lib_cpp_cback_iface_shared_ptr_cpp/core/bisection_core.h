/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef BISECTION_CORE_H_
#define BISECTION_CORE_H_

#include "structures/bisection_options.h"
#include "structures/bisection_internals.h"
#include "utilities/utilities_general.h"

#include<math.h>
#include<stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

int
bisection_method
(
  const BisectionOptions * ptr_opt ,
        SolnIterates     * soln
);

#ifdef __cplusplus
}
#endif

#endif