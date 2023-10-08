module BranchMux(
    input wire branch,
    input wire [2:0] ccc,
    input [2:0] Flag,
    output wire branch_out
);
    reg temp;

    // Flag[2] = Z Flag[1] = V Flag[0] = N 
    always @(ccc, Flag) begin
        case (ccc)
            4'b0000: temp = ~Flag[2];
            4'b0001: temp = Flag[2];
            4'b0010: temp = ~(Flag[2] | Flag[0]);
            4'b0011: temp = Flag[0];
            4'b0100: temp = Flag[2] || (Flag[2] == 0 && Flag[0] == 0);
            4'b0101: temp = Flag[2] || Flag[0];
            4'b0110: temp = Flag[1];
            default: temp = 1;
        endcase
    end

    assign branch_out = temp & branch;
endmodule
