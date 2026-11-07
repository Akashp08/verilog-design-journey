module vending_machine (
    input clk,
    input rst,
    input N, // Nickel (5c)
    input D, // Dime (10c)
    output reg dispense
);

    // State Encodings
    parameter S0 = 2'b00, S5 = 2'b01, S10 = 2'b10, S15 = 2'b11;
    reg [1:0] current_state, next_state;

    // 1. State Memory (Flip-Flops)
    always @(posedge clk or posedge rst) begin
        if (rst) 
            current_state <= S0;
        else 
            current_state <= next_state;
    end

    // 2. Next State Logic (Combinational)
    always @(*) begin
        case (current_state)
            S0: begin
                if (N) next_state = S5;
                else if (D) next_state = S10;
                else next_state = S0;
            end
            S5: begin
                if (N) next_state = S10;
                else if (D) next_state = S15;
                else next_state = S5;
            end
            S10: begin
                if (N || D) next_state = S15; 
                else next_state = S10;
            end
            S15: begin
                next_state = S0; // Dispense complete, auto-reset to 0c
            end
            default: next_state = S0;
        endcase
    end

    // 3. Output Logic (Moore Machine)
    always @(*) begin
        if (current_state == S15)
            dispense = 1;
        else
            dispense = 0;
    end

endmodule