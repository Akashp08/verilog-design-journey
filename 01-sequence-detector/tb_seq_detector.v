`timescale 1ns / 1ps

module tb_seq_detector();

    reg clk;
    reg rst;
    reg din;
    wire dout;

    // Instantiate the module (like calling a function)
    seq_detector_1001_mealy uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(dout)
    );

    // Generate a clock: toggles every 5 nanoseconds
    always #5 clk = ~clk;

    initial begin
        // GTKWave Dump commands
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_seq_detector);

        // Initialize values
        clk = 0; rst = 1; din = 0;
        
        // Release reset after 10ns
        #10 rst = 0;

        // Apply input sequence: 1 0 0 1 0 0 1 (Overlapping 1001)
        #10 din = 1; 
        #10 din = 0; 
        #10 din = 0; 
        #10 din = 1; // First 1001 detected here -> dout should blip high
        #10 din = 0; 
        #10 din = 0; 
        #10 din = 1; // Second 1001 detected here (Overlap) -> dout blips high
        #10 din = 0;
        
        #20 $finish; // End simulation
    end
endmodule