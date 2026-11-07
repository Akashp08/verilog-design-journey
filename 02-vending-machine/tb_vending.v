`timescale 1ns / 1ps

module tb_vending();

    reg clk, rst, N, D;
    wire dispense;

    vending_machine uut (
        .clk(clk), .rst(rst), .N(N), .D(D), .dispense(dispense)
    );

    // 5ns clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("vending.vcd");
        $dumpvars(0, tb_vending);

        clk = 0; rst = 1; N = 0; D = 0;
        
        // Clear reset
        #10 rst = 0;

        // Test Case 1: Three Nickels (5 + 5 + 5 = 15)
        #10 N = 1; D = 0; // Insert Nickel (Total: 5c)
        #10 N = 1; D = 0; // Insert Nickel (Total: 10c)
        #10 N = 1; D = 0; // Insert Nickel (Total: 15c -> should dispense)
        #10 N = 0; D = 0; // Wait
        
        // Test Case 2: Dime + Nickel (10 + 5 = 15)
        #20 D = 1; N = 0; // Insert Dime (Total: 10c)
        #10 N = 1; D = 0; // Insert Nickel (Total: 15c -> should dispense)
        #10 N = 0; D = 0; // Wait

        // Test Case 3: Dime + Dime (10 + 10 = 20 -> Dispense anyway)
        #20 D = 1; N = 0; // Insert Dime (Total: 10c)
        #10 D = 1; N = 0; // Insert Dime (Total: 15c threshold hit)
        #10 D = 0; N = 0; // Wait
        
        #20 $finish;
    end
endmodule