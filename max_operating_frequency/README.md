# TCL script that finds the maximum operating frequency of a design for FPGA using Vivado as backend  

The maximum operating frequency is a fundamental metric that dictates how fast a digital system can operate reliably. It is defined as the highest clock frequency at which the circuit can operate without violating timing constraints, particularly setup time at flipflops. f_max = 1/T_min, where T_min is the minimum allowable clock period and is constrained by the Critical path of the circuit.  

Wrapping registers around the inputs and output ports of a combinational design and finding the maximum operating frequency is a commonly practised method for delay benchmarking. In Vivado tool, the Worst Negative Slack and Worst Pulse Width Slack are two characteristic quantities to identify timing violations.  (I haven't ever seen WHS<0 and am looking for formal references about the same). For the design to meet timing, WNS, WPWS and WHS > 0 and TNS, THS and TPWS = 0.  

Maximum operating frequency corresponds to the implementation with reported WNS nearly 0 and WPWS > 0. However, to obtain this, the designer has to manually update the clock constraints and check the stated condition.  


We draw an analogy between the beformentioned process and solving the roots of a function. Where the functions are WNS and WPWS with respect to clock period. The clock period corresponding to 0 WNS while WPWS > 0 is the minimum allowable clock period.  

```text
WNS = Required Time - Arrival Time
    = (Clock Period - Setup Time) - Arrival Time
    = Clock Period - (Setup Time + Arrival Time)
```

From the above equation, we can theoretically expect the WNS to be a linear function with slope 1 and roots = Setup Time + Arrival Time. However, for each implementation, Vivado tends to modify the design so as to meet the timing constraints for the specific implementation. (references)  
Although a bisection method can be used to obtain an approximate root (corresponding to Minimum allowed clock period), irrespective of the nature of the relationship, this method can become too time consuming owing to the resource intensive task of Vivado Synthesis and Implementation. Depending on the initial lower bound, upper bound and root tolerance(a,b,e respectively) of the binary search, the average number of iterations before the root is found would be log_2(b-a/e)-1.  

Having some prior knowledge on the characteristics of the relationship would help device a strategy for efficiently finding the T_min.  

For several designs, we swept the clock period over a certain range, dynamically updating the clock constraints and extracting the WNS, WPWS, WHS data from the timing summary report.  

Goal :  
To empirically characterize whether WNS vs. Clock Period behaves linearly or non-linearly across implementations.   

---
Design : Adder N64M34  
Device : xc7a200tlffv1156-2L  
![add](https://github.com/AbhijitBaral/delay_automation_combinational_designs/blob/main/max_operating_frequency/plots/N64M34.png)  

---
Design : Adder N64M64  
Device : xc7a200tlffv1156-2L  
![adwqd](https://github.com/AbhijitBaral/delay_automation_combinational_designs/blob/main/max_operating_frequency/plots/N64M64.png)  

---
Design : Adder N64M30  
Device : xc7vx690t_CIVffg1930-3  
![addwq](https://github.com/AbhijitBaral/delay_automation_combinational_designs/blob/main/max_operating_frequency/plots/N64M30.png)  


---
Design : Adder N64M6  
Device : xc7vx690t_CIVffg1930-3  
![addwq](https://github.com/AbhijitBaral/delay_automation_combinational_designs/blob/main/max_operating_frequency/plots/N64M64.png)  

--- 
```verilog
module multiplier(
    input [7:0] A,B,
    output [15:0]mul
    );
    
    assign mul = A * B;
endmodule
```
Design : Behavioural multiplier (Fixed Location)  
Device : xa7a100tcsg324-2I  
![dwe](https://github.com/AbhijitBaral/delay_automation_combinational_designs/blob/main/max_operating_frequency/plots/multiplier(fixed).png)  

---
Design : Behavioural Multiplier (No placement constraints)  
Device : xa7a100tcsg324-2I  
![multFree](https://github.com/AbhijitBaral/delay_automation_combinational_designs/blob/main/max_operating_frequency/plots/Multiplier(free).png)  

---  

Design : Square Root CAS_8 Bit (No placement constraints)  
Device : xc7v585tffg1761-3  
![bfg](https://github.com/AbhijitBaral/delay_automation_combinational_designs/blob/main/max_operating_frequency/plots/square_root_CAS_8bit.png)   

---
Design : Square Root CAS_32 Bit (No Placement constraints)  
Device : xc7v585tffg1761-3  
![ntrt](https://github.com/AbhijitBaral/delay_automation_combinational_designs/blob/main/max_operating_frequency/plots/square_root_CAS_32bit.png)  


The above experiments support the analogy between the problem of determining Tmin⁡​ and solving WNS(T) = 0, with WPWS(T) > 0 as a secondary constraint.
The WNS curve closely follows a linear trend with slope ~1 (as expected from the WNS equation). The WPWS curve appears to be strictly increasing and smooth, with an offset linear rise.  

---
Algorithm:  
![algo](https://github.com/AbhijitBaral/delay_automation_combinational_designs/blob/main/max_operating_frequency/plots/flow_chart.drawio.png)
