/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef MEX_LOADER_BASE_HPP_
#define MEX_LOADER_BASE_HPP_

#include "mex.h"

#include <dlfcn.h>

#include <iostream>
#include <string>
#include <stdio.h>

typedef void (*entryfunc_t)(int, mxArray**, int, const mxArray**);

namespace mex_loaders
{
  
template <typename T>
class MEX_Loader_Base
{
public:
  
  static
  void
  LibLoader_constructor
  ()
  {
    std::cout << "LibLoader of " << base_get_class_name() << " constructor called." << std::endl;
    
    char str[2048];
    sprintf( str , "%s/%s" , T::get_PATH_LOADED_MEX() , T::get_NAME_LOADED_MEX() );

    T::set_gMexEntry(NULL);
      
    std::cout << "Loading library (\"" << T::get_NAME_LOADED_MEX() << "\")" << std::endl;
      
    dlerror();
    T::set_fh( dlopen ( str , RTLD_NOW | RTLD_DEEPBIND ) );
    if ( !T::get_fh() ) 
    {
      T::set_flag_loadedLib(false);
        
      std::cout << "Library handle (\"" << T::get_NAME_LOADED_MEX() << "\") is NULL." << std::endl;
      std::cout << "Cannot load library (\"" << T::get_NAME_LOADED_MEX() << "\"):" << std::endl << dlerror() << std::endl;
    }
    else 
    {
      T::set_flag_loadedLib(true);
        
      std::cout << "Library handle (\"" << T::get_NAME_LOADED_MEX() << "\") is not NULL." << std::endl;
      std::cout << "Loading symbol (\"mexFunction\")." << std::endl;

      dlerror();
      T::set_p( dlsym  (T::get_fh(), "mexFunction") );
      const char* dlsym_error = dlerror();
      if (dlsym_error) 
      {
        T::set_flag_loadedSymbol(false);
        std::cout << "Cannot load symbol (\"mexFunction\"): " << std::endl << dlsym_error << std::endl;
      }
      else {
        T::set_flag_loadedSymbol(true);
        T::set_gMexEntry( reinterpret_cast<entryfunc_t> (T::get_p()) );
        std::cout << "Symbol loaded (\"mexFunction\"). " << std::endl;
      }
    }
  }
  
  static
  void
  LibLoader_destructor
  ()
  {
    std::cout << "LibLoader of "<< base_get_class_name() <<" destructor called." << std::endl;
    
    if ( T::get_flag_loadedLib() ) 
    {
      dlclose( T::get_fh() );
      std::cout << "Closed library (\"" << T::get_NAME_LOADED_MEX() << "\")" << std::endl;
    }
    else 
    {
      std::cout << "Could not load and now not closing library (\"" << T::get_NAME_LOADED_MEX() << "\")" << std::endl;
    }
  }
  
  static
  const char * 
  base_get_class_name()
  {
    return T::get_class_name();
  }
  
  static
  const char * 
  base_get_PATH_LOADED_MEX()
  {
    return T::get_PATH_LOADED_MEX();
  }
  
  static
  const char * 
  base_get_NAME_LOADED_MEX()
  {
    return T::get_NAME_LOADED_MEX();
  }
  
  static
  void
  base_set_gMexEntry
  (entryfunc_t e)
  {
    T::set_gMexEntry(e);
  }
  
  static
  entryfunc_t
  base_get_gMexEntry
  ()
  {
    return T::get_gMexEntry();
  }
  
  static
  void
  base_set_fh
  (void *fh)
  {
    T::set_fh(fh);
  }
  
  static
  void *
  base_get_fh()
  {
    return T::get_fh();
  }
  
  static
  void
  base_set_p
  (void *p)
  {
    T::set_p(p);
  }
  
  static
  void *
  base_get_p
  ()
  {
    return T::get_p();
  }
  
  static
  void
  base_set_flag_loadedLib
  (bool flag)
  {
    T::set_flag_loadedLib(flag);
  }
  
  static
  bool
  base_get_flag_loadedLib()
  {
    return T::get_flag_loadedLib();
  }
  
  static
  void
  base_set_flag_loadedSymbol
  (bool flag)
  {
    T::set_flag_loadedSymbol(flag);
  }
  
  static
  bool
  base_get_flag_loadedSymbol()
  {
    return T::get_flag_loadedSymbol();
  }
  
private:
  MEX_Loader_Base() {}
  
protected:
  static std::string  class_name_;
  static std::string  lib_path_;
  static std::string  lib_name_;
  
  static entryfunc_t  gMexEntry_;
  
  static void        *fh_; // library handle
  static void        *p_;  // symbol handle
  
  static bool         flag_loadedLib_;
  static bool         flag_loadedSymbol_;
  
};

template <typename T>
std::string  MEX_Loader_Base<T>::class_name_        = "";
template <typename T>
std::string  MEX_Loader_Base<T>::lib_path_          = "";
template <typename T>
std::string  MEX_Loader_Base<T>::lib_name_          = "";

template <typename T>
entryfunc_t   MEX_Loader_Base<T>::gMexEntry_        = NULL;

template <typename T>
void        * MEX_Loader_Base<T>::fh_               = NULL;
template <typename T>
void        * MEX_Loader_Base<T>::p_                = NULL;

template <typename T>
bool          MEX_Loader_Base<T>::flag_loadedLib_   = false;
template <typename T>
bool          MEX_Loader_Base<T>::flag_loadedSymbol_= false;

}

#endif