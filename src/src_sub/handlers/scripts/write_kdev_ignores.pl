#!/usr/bin/perl

# /*
#  * This file is part of the "dev-in-place" repository located at:
#  * https://github.com/osuvak/dev-in-place
#  * 
#  * Copyright (C) 2017  Onder Suvak
#  * 
#  * For licensing information check the above url.
#  * Please do not remove this header.
#  * */

use strict;
use warnings;

use POSIX;
use POSIX qw(strftime);
use feature qw(switch);
use Cwd qw(); 

foreach my $item (@ARGV)
{
  open ( FILE , ">${item}/.kdev_ignore" );
  close( FILE );
}