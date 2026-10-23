`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2026 20:06:52
// Design Name: 
// Module Name: assig_q1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module assig_q1(
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [7:0] a,
    input  wire [7:0] b,

    output reg  [7:0] q,
    output reg  [7:0] r,
    output reg        done
);

    localparam IDLE = 2'b00,
               RUN  = 2'b01,
               DONE = 2'b10;

    reg [1:0] state;

    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] R;
    reg [7:0] Q;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            A     <= 8'd0;
            B     <= 8'd0;
            R     <= 8'd0;
            Q     <= 8'd0;
            q     <= 8'd0;
            r     <= 8'd0;
            done  <= 1'b0;
        end
        else begin
            case (state)

                IDLE: begin
                    done <= 1'b0;

                    if (start) begin
                        A     <= a;
                        B     <= b;
                        R     <= a;
                        Q     <= 8'd0;
                        state <= RUN;
                    end
                end

                RUN: begin
                    if (R >= B) begin
                        R <= R - B;
                        Q <= Q + 8'd1;
                    end
                    else begin
                        q     <= Q;
                        r     <= R;
                        state <= DONE;
                    end
                end

                DONE: begin
                    done  <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                    done  <= 1'b0;
                end

            endcase
        end
    end

endmodule

