# Automated Design Flow for performance evaluation of Combiational circuit designs  

 
## Design flow  
`for each N in N_set:
    For each M from 0 to N:
        1. Generate parameterized Verilog module using N and M
           → Save to: ./design_modules/

        2. Create a new Vivado project
           → Project name: mn_adder_N<N>M<M>
           → Directory: ./design_sweep_runs/mn_adder_N<N>M<M>/

        3. Add generated source files to the project and set top module

        4. Perform delay computation:
           a. Generate a timing constraint file (XDC)
              - Define input clock or I/O delay
           b. Run synthesis and implementation
              - Command:
                launch_runs impl_1 -to_step write_bitstream
	   c
	   :
	   :
	   .  Return operating frequency/ delay of combinational design
           
        5. Store timing result
           → Format: CSV or plain text
           → Save to: ./reports/N_<N>_M_<M>/timing_summary
	
	6 . Generate timing report
              - Command:
                report_timing_summary

        7. Close the project and clean up intermediate files
`
