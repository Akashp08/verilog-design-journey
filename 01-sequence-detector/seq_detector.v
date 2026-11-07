module seq_detector_1001_mealy (
    input clk,
    input rst,
    input din,
    output reg dout
);

    // State Encoding (Like enums in C)
    parameter S_IDLE = 2'b00, S_1 = 2'b01, S_10 = 2'b10, S_100 = 2'b11;

    // Registers to hold state
    reg [1:0] current_state, next_state;

    // BLOCK 1: Sequential Logic (The Flip-Flops)
    // Updates current_state on every rising clock edge.
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S_IDLE;      // Non-blocking (<=) for sequential
        else
            current_state <= next_state;
    end

    // BLOCK 2: Combinational Logic (Next State Logic)
    // Executes like a switch-case in C. Updates whenever current_state or din changes.
    always @(*) begin
        case (current_state)
            S_IDLE: next_state = din ? S_1 : S_IDLE;
            S_1:    next_state = din ? S_1 : S_10;
            S_10:   next_state = din ? S_1 : S_100;
            S_100:  next_state = din ? S_1 : S_IDLE; // If din=1, overlap back to S_1!
            default: next_state = S_IDLE;
        endcase
    end

    // BLOCK 3: Combinational Logic (Output Logic - Mealy)
    // Output depends on current state AND input (din)
    always @(*) begin
        if (current_state == S_100 && din == 1)
            dout = 1;
        else
            dout = 0;
    end

endmodule