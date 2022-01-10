// adapted from neorv32/sw/example/blink_led

// #################################################################################################
// # << NEORV32 - Blinking LED Demo Program >>                                                     #
// # ********************************************************************************************* #
// # BSD 3-Clause License                                                                          #
// #                                                                                               #
// # Copyright (c) 2021, Stephan Nolting. All rights reserved.                                     #
// #                                                                                               #
// # Redistribution and use in source and binary forms, with or without modification, are          #
// # permitted provided that the following conditions are met:                                     #
// #                                                                                               #
// # 1. Redistributions of source code must retain the above copyright notice, this list of        #
// #    conditions and the following disclaimer.                                                   #
// #                                                                                               #
// # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     #
// #    conditions and the following disclaimer in the documentation and/or other materials        #
// #    provided with the distribution.                                                            #
// #                                                                                               #
// # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  #
// #    endorse or promote products derived from this software without specific prior written      #
// #    permission.                                                                                #
// #                                                                                               #
// # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   #
// # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               #
// # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    #
// # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     #
// # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE #
// # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    #
// # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     #
// # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  #
// # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            #
// # ********************************************************************************************* #
// # The NEORV32 Processor - https://github.com/stnolting/neorv32              (c) Stephan Nolting #
// #################################################################################################


/**********************************************************************//**
 * @file test01_riscv_blinky/main.c
 * @author Mike Ng
 * @brief Fancier blinky for 4 LEDs on SQRL Acorn / RHS NiteFury
 **************************************************************************/

#include <neorv32.h>

/**********************************************************************//**
 * C function to blink LEDs
 **************************************************************************/
void blink_led_c(void);


/**********************************************************************//**
 * Main function; shows an incrementing 8-bit counter on GPIO.output(7:0).
 *
 * @note This program requires the GPIO controller 
 *
 * @return 0 if execution was successful
 **************************************************************************/
int main() {

  blink_led_c();

  return 0;
}


/**********************************************************************//**
 * C-version of blinky LED counter
 **************************************************************************/
void blink_led_c(void) {

  neorv32_gpio_port_set(0); // clear gpio output

  int cnt = 0;
  int pwm = 1;
  int up = 1;
  const int PWM_PERIOD_MS = 16; // 60ish Hz

  // use delay_ms to do software PWM on the count
  // for a fade effect
  while (1) {
    neorv32_gpio_port_set(cnt & 0xFF);
    neorv32_cpu_delay_ms(pwm);
    neorv32_gpio_port_set(0x0);    
    neorv32_cpu_delay_ms(PWM_PERIOD_MS-pwm);
    if (pwm==PWM_PERIOD_MS) {
        up = 0;
    } else if (pwm==0) {
        up = 1;
        cnt = cnt + 1;
    }
    pwm = up ? pwm+1 : pwm-1;
  }
}
