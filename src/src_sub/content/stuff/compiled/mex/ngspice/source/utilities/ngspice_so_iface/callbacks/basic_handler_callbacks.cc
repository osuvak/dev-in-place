/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */


#include "callbacks/basic_handler_callbacks.hh"

int
ng_getchar
(
  char *outputreturn ,
  int   ident ,
  void *userdata
)
{
  using namespace ngspice::mexInterface;
  BasicNGSpiceHandler *mpt = static_cast<BasicNGSpiceHandler*>(userdata);
  
  std::string s(outputreturn);
  mpt->appendToStrCollector(s);
  
  if ( mpt->report_on_stdout() )
    printf("%s\n", outputreturn);
  
  return 0;
}


int
ng_getstat
(
  char *outputreturn ,
  int   ident ,
  void *userdata
)
{
  using namespace ngspice::mexInterface;
  BasicNGSpiceHandler *mpt = static_cast<BasicNGSpiceHandler*>(userdata);
  
  std::string s(outputreturn);
  mpt->appendToStrCollector(s);
  
  if ( mpt->report_on_stdout() )
    printf("%s\n", outputreturn);
  
  return 0;
}

int
ng_thread_runs
(
  bool  noruns ,
  int   ident ,
  void *userdata
)
{
  using namespace ngspice::mexInterface;
  BasicNGSpiceHandler *mpt = static_cast<BasicNGSpiceHandler*>(userdata);
  
  mpt->work_being_done(!noruns);

  char msg_NotRunning[] = "bg not running";
  char msg_Running   [] = "bg running";
  
  if (noruns)
  {
    std::string s(msg_NotRunning);
    mpt->appendToStrCollector(s);
    if ( mpt->report_on_stdout() )
      printf("%s\n",msg_NotRunning);
  }
  else
  {
    std::string s(msg_Running);
    mpt->appendToStrCollector(s);
    if ( mpt->report_on_stdout() )
      printf("%s\n",msg_Running);
  }
  
  return 0;
}

/* Callback function called from bg thread in ngspice once per accepted data point */
int
ng_data
(
  pvecvaluesall  vdata ,
  int            numvecs ,
  int            ident ,
  void          *userdata
)
{
  return 0;
}

/* Callback function called from bg thread in ngspice once upon intialization
   of the simulation vectors)*/
int
ng_initdata
(
  pvecinfoall  intdata ,
  int          ident ,
  void        *userdata
)
{
  using namespace ngspice::mexInterface;
  BasicNGSpiceHandler *mpt = static_cast<BasicNGSpiceHandler*>(userdata);

  int noVectors = intdata->veccount;
  mpt->totalNoVectors(noVectors);
  
  return 0;
}

/* Callback function called from bg thread in ngspice if fcn controlled_exit()
   is hit. Do not exit, but unload ngspice. */
int
ng_exit
(
  int   exitstatus ,
  bool  immediate ,
  bool  quitexit ,
  int   ident ,
  void *userdata
)
{
  using namespace ngspice::mexInterface;
  BasicNGSpiceHandler *mpt = static_cast<BasicNGSpiceHandler*>(userdata);

  if(quitexit) 
  {
    char msg[256];
    sprintf( msg , "DNote: Returned from quit with exit status %d." , exitstatus );
    std::string s(msg);
    mpt->appendToStrCollector(s);
    if ( mpt->report_on_stdout() )
      printf("%s\n", msg);
    
    /* we will decide when to exit*/
//     exit(exitstatus);
  }
  if(immediate) 
  {
    if ( mpt->report_on_stdout() )
    {
      printf("DNote: Unloading ngspice inmmediately is not possible\n");
      printf("DNote: Can we recover?\n");
    }
  }
  else 
  {
    if ( mpt->report_on_stdout() )
    {
      printf("DNote: Unloading ngspice is not possible\n");
      printf("DNote: Can we recover? Send 'quit' command to ngspice.\n");
    }

    /* sets an error flag flag here in the example. */
//     errorflag = true;
//     ngSpice_Command("quit 5");
  }

  return exitstatus;
}

/* Funcion called from main thread upon receiving signal SIGTERM */
void
alterp
(
  int sig
)
{
  ngSpice_Command("bg_halt");
}


/* Case insensitive str eq. */
/* Like strcasecmp( ) XXX */
int
cieq
(
  register char *p ,
  register char *s
)
{
  while (*p) 
  {
    if 
      ( 
        (isupper(*p) ? tolower(*p) : *p) !=
        (isupper(*s) ? tolower(*s) : *s)
      )
      return(false);
    p++;
    s++;
  }
  return (*s ? false : true);
}
 