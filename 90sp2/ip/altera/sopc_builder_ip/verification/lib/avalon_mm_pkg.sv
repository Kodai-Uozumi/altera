// $Id: //acds/rel-r/9.0sp2/ip/sopc/components/verification/lib/avalon_mm_pkg.sv#1 $
// $Revision: #1 $
// $Date: 2009/04/01 $
//-----------------------------------------------------------------------------
// =head1 NAME
// avalon_mm_pkg
// =head1 SYNOPSIS
// Package for shared Avalon MM component types.
//-----------------------------------------------------------------------------
// =head1 COPYRIGHT
// Copyright (c) 2008 Altera Corporation. All Rights Reserved.
// The information contained in this file is the property of Altera
// Corporation. Except as specifically authorized in writing by Altera 
// Corporation, the holder of this file shall keep all information 
// contained herein confidential and shall protect same in whole or in part 
// from disclosure and dissemination to all third parties. Use of this 
// program confirms your agreement with the terms of this license.
//-----------------------------------------------------------------------------
// =head1 DESCRIPTION
// This package contains shared non-parameterized type definitions.
// =cut

`ifndef _AVALON_MM_PKG_
`define _AVALON_MM_PKG_

package avalon_mm_pkg;
   
   // transaction request types
   typedef enum int {
		     REQ_READ = 0, 
                     REQ_WRITE = 1,
		     REQ_IDLE = -1
                     } Request_t;

endpackage
   
// =cut
`endif
   
