/* File : libspot.i */

%feature("autodoc", "3");
%feature("notabstract") DSpot;


// headers in the module
%module pyspot // namespace
%{
#include "ubend.h"
#include "streamstats.h"
#include "bounds.h"
#include "brent.h"
#include "gpdfit.h"
#include "spot.h"
#include "dspot.h"
%}

// C++ declarations
%include "std_string.i"
%include "std_vector.i"
%include "std_pair.i"

// doxygen
%include "docs.i"

namespace std {
   %template(DoubleVector) vector<double>;
   %template() std::pair<int,int>;
}

%include "ubend.h"
%include "streamstats.h"
%include "bounds.h"
%include "brent.h"
%include "gpdfit.h"
%include "spot.h"
%include "dspot.h"

%varargs(10, Args &) DSpot::DSpot;
%feature("python:cdefaultargs") DSpot::DSpot;
DSpot::DSpot(int d, ...);


