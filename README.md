###   4-Bit Synchronous Counter
#### 📍 Complete RTL → GDSII ASIC Implementation (Cadence Flow)

##### About The Project
This repository showcases the complete ASIC implementation flow of a 4-bit synchronous counter, starting from RTL design and ending at GDSII layout generation using industry-standard Cadence EDA tools.

The goal of this project was not just to design a counter, but to understand how a digital design transforms into real silicon-ready layout through every stage of the ASIC flow.

##### This project covers:
            ✔ RTL Design
            ✔ Functional Verification
            ✔ Timing Constraints (SDC)
            ✔ Logic Synthesis
            ✔ Floorplanning
            ✔ Placement
            ✔ Clock Tree Synthesis (CTS)
            ✔ Routing
            ✔ DRC & LVS
            ✔ GDSII Generation

##### Design Overview

###### The 4-bit synchronous counter:

           - Increments on every positive clock edge
           - Resets to 0000 when reset is asserted
           - Fully synthesizable
           - Single clock domain
           - Designed for clean timing closure

##### Tools & Technologies Used

| Stage                 | Tool Used | Purpose                       |
| --------------------- | --------- | ----------------------------- |
| Simulation            | Incisive  | RTL Functional Verification   |
| Synthesis             | Genus     | Gate-level netlist generation |
| Physical Design       | Innovus   | Placement, CTS, Routing       |
| Physical Verification | PVS       | DRC & LVS Checks              |
| HDL                   | Verilog   | RTL Design                    |
| Constraints           | SDC       | Timing Definition             |

##### Complete ASIC Flow
###### 1️⃣ RTL Design

          - Written in Verilog HDL
          - Clean, synthesizable code style
        
```verilog 
`timescale 1ps/1ps
// Module Declaration
module counter(clk,m,rst,count);

// input & output ports declaration
input clk,m,rst;
output reg [3:0] count ;

// The Block is executed when either of positive edge of the clock 
// Both are independent events or neg edge of the rst arrives

always @(posedge clk or negedge rst) begin
    if (!rst)
    count=0;
    else if(m)  // high for up counter and low for down counter
    count = count + 1;

    else
    count = count - 1; 
end
endmodule

```
##### 2️⃣ Functional Verification
###### Verified:

        - Clock behavior
        - Reset functionality
        - Count sequence correctness

``` verilog
`timescale 1ps/1ps
module Counter_test;
reg clk,rst,m;
wire [1:0] count ;

initial begin
    clk=0;              // initializing clock and reset
    rst=0; #100       // all outputs are 4'b0000 from time t=0 to t=100ns
    rst=1;    // updown counting is allowed at posedge clk
end
initial 
begin
    m=0; //  condition for down counting
    #600 m=1; // condition for up counting 
    #500 m=0;
end
counter uut(clk,m,rst,count);   //Instructions of source code
always #5 clk=~clk;
initial $monitor("Time=%t rst=%b clk=%b count=%b", $time,rst,clk,count);
initial
#1400 $finish;   // finishing Simul;ation at t=1400ns

endmodule

```
###### Timing Waveform

![timing image](C:/Users\Jyotishman\OneDrive\Desktop\PROJECTS\COUNTER\timing.png)

##### 3️⃣ Logic Synthesis (Genus)

          - RTL → Gate-level netlist
          - Timing optimization
          - Area and power estimation
          - Report generation
###### Input Files

          - Timing Constraints File (SDC)
          - Tool Command LanguageFile (tcl)
          - Verilog Code (counter.v) 
        
##### Outputs Generated :

          - Synthesized netlist
          - Timing report
          - Area report
          - Power report


##### 1. Timing Constraints (SDC)
###### Defined:

        - Clock (period, waveform)
        - Clock uncertainty
        - Input/Output delays
        - Transition constraints
        - Load constraints
        - Max fanout

``` verilog
create_clock -name clk -period 2 -waveform {0 1} [get_ports "clk"]
set_clock_transition -rise 0.1 [get_clocks "clk"]
set_clock_transition -fall 0.1 [get_clocks "clk"]
set_clock_uncertainty 0.01 [get_ports "clk"]
set_input_transition 0.12 [all_inputs]
set_input_delay -max 0.8 [get_ports "clk"] -clock [get_clocks "clk"]
set_input_delay -max 0.8 [get_ports "reset"] -clock [get_clocks "clk"]
set_output_delay -max 0.8 [get_ports "count"] -clock [get_clocks "clk"]
set_load 0.15 [all_outputs]
set_max_fanout 20.00 [current_design]

```

##### 2. Tool Command LanguageFile (counter.tcl)
```verilog
read_libs /home/install/FOUNDRY/digital/90nm/lib/slow.lib

#Input files

read_hdl counbter.v

elaborate counter 

read_sdc constraints_top.sdc

set_db syn_generic_effort medium

syn_generic
 
set_db syn_map_effort medium

syn_map

set_db syn_opt_effort medium

syn_opt

#Reports

report_timing > counter_timing.rep
report_area > counter_area.rep
report_power > counter_power.rep
report_gate > counter_gate.rep

#Output files

write_hdl > counter_netlist.v
write_sdc > constraints_top_output.sdc

exit
```
##### Schematic
![Schematic](C:/Users\Jyotishman\OneDrive\Desktop\PROJECTS\COUNTER\schematic.png)
##### 4️⃣ Physical Design (Innovus)
###### 1. Floorplanning

          - Core utilization setup
          - IO placement
###### 2. Power Planning

          - Power rings and stripes

###### 3. Placement

          - Standard cell placement
          - Congestion analysis

###### 4. Clock Tree Synthesis (CTS)

          - Clock buffer insertion
          - Skew optimization
          - Latency balancing
```VERILOG
#90nm technology
## Clock Tree constraints used for Building and Balancing the Clock Tree in CTS Stage

## Creating NDR Rules:
add_ndr -width {Metal1 0.24 Metal2 0.28 Metal3 0.28 Metal4 0.28 Metal5 0.28 Metal6 0.28 Metal7 0.28 Metal8 0.88 Metal9 0.88 } -spacing {Metal1 0.24 Metal2 0.28 Metal3 0.28 Metal4 0.28 Metal5 0.28 Metal6 0.28 Metal7 0.28 Metal8 0.8 Metal9 0.8 } -name 2W2S

## Create a route type to define the NDR & layers to use for routing the clock tree:
create_route_type -name clkroute -non_default_rule 2W2S -bottom_preferred_layer Metal5 -top_preferred_layer Metal6

## specify this route type should be used for trunk and leaf nets:
set_ccopt_property route_type clkroute -net_type trunk
set_ccopt_property route_type clkroute -net_type leaf

## specify the Clock Buffer, Clock Inverter & Clock Gating Cells to use:
set_ccopt_property buffer_cells {CLKBUFX6 CLKBUFX8 CLKBUFX12}
set_ccopt_property inverter_cells {CLKINVX6 CLKINVX8 CLKINVX12}
set_ccopt_property clock_gating_cells TLATNTSCA

## Generate the CCOpt spec file & source it:
create_ccopt_clock_tree_spec -file ccopt.spec
source ccopt.spec

## Run CCOpt-CTS:
ccopt_design -cts

## Generate Reports for Clock Tree & Skew Groups
report_ccopt_clock_trees -file clk_trees.rpt
report_ccopt_skew_groups -file skew_groups.rpt

## Save the Design
saveDesign DBS/cts.enc

```

###### 5. Routing

          - Global routing
          - Detailed routing
          - Post-route optimization

###### Input Files
          - Logic Library (.lib)
          - Gate Level Netlist
          - Constraints(.sdc)
          - Physical Libraries (.LEF)
          - Physical Libraries (tech.LEF)
###### Output Files
          - Reports
          - GDSII
##### Physical Design
![physical design](C:/Users\Jyotishman\OneDrive\Desktop\PROJECTS\COUNTER\pd.png)
##### 5️⃣ Physical Verification (PVS)

          ✅ Design Rule Check (DRC)
          ✅ Layout vs Schematic (LVS)

###### Ensured:

          -Manufacturing rule compliance
          -Logical equivalence with netlist

##### 6️⃣ GDSII Generation

           After successful DRC & LVS:
        
##### 🤝 Connect With Me
Author: Jyotishman Sarmah
Domain: VLSI | ASIC Design | Physical Design
Email: jyotishmansarmah255@gmail.com
Linkedin: https://www.linkedin.com/in/jyotishman-sarmah-b9b735284/ 