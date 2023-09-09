/*
    The purpose of this file is to include the actual tx_port.h file for current
   cpu architecture Author: Neo Xiong <xiongyu0523@gmail.com>
*/
#pragma once

#if (defined(__TARGET_CPU_CORTEX_M0PLUS) || defined(__TX_CORTEX_M0))
#include "../ports/cortex_m0/include/tx_port.h"
#elif (defined(__TARGET_CPU_CORTEX_M4) || defined(__TX_CORTEX_M4))
#include "../ports/cortex_m4/include/tx_port.h"
#elif (defined(__TARGET_CPU_CORTEX_M7) || defined(__TX_CORTEX_M7) ||           \
       defined(__IMXRT1062__))
#include "../ports/cortex_m7/include/tx_port.h"
#else
#warning                                                                       \
    "Attempting to compile with ThreadX Cortex M0 port as a default, this may not work!"
#include "../ports/cortex_m0/include/tx_port.h"
#endif
