  
`timescale 1ns/1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2026 20:14:53
// Design Name: 
// Module Name: assig_q1_tb
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



module assig_q1_tb;

    reg        clk, rst, start;
    reg  [7:0] a, b;
    wire       done;
    wire [7:0] q, r;

    integer edges, divisions, errors, on_time;

    assig_q1 dut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .a     (a),
        .b     (b),
        .done  (done),
        .q     (q),
        .r     (r)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task divide;
        input [7:0] ta, tb;
        reg   [7:0] mq, mr;
        begin
            mq = ta / tb;
            mr = ta % tb;

            @(negedge clk);
            a = ta;
            b = tb;
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            edges = 0;

            while (done !== 1'b1 && edges < 600) begin
                @(posedge clk);
                #1;
                edges = edges + 1;
            end

            divisions = divisions + 1;

            if (done !== 1'b1) begin
                errors = errors + 1;
                $display(
                    "a=%3d b=%3d: done never came (600 edges) FAIL",
                    ta, tb
                );
            end
            else begin
                if (q !== mq || r !== mr)
                    errors = errors + 1;

                if (edges == mq + 1)
                    on_time = on_time + 1;

                $display(
                    "a=%3d b=%3d q=%3d r=%3d (model q=%3d r=%3d) done after %3d edges %0s",
                    ta, tb, q, r, mq, mr, edges,
                    (q === mq && r === mr) ? "ok" : "WRONG"
                );
            end

            @(negedge clk);
        end
    endtask

    initial begin
        divisions = 0;
        errors    = 0;
        on_time   = 0;
        edges     = 0;

        start = 1'b0;
        a     = 8'd0;
        b     = 8'd1;
        rst   = 1'b1;

        repeat (2) @(negedge clk);
        rst = 1'b0;

        divide(8'd7,   8'd2);
        divide(8'd100, 8'd7);
        divide(8'd255, 8'd1);
        divide(8'd0,   8'd5);
        divide(8'd5,   8'd9);
        divide(8'd200, 8'd200);
        divide(8'd255, 8'd16);
        divide(8'd37,  8'd3);

        $display(
            "assig_q1_tb: %0d divisions, %0d mismatches -> %s; done after q+1 edges on %0d of %0d",
            divisions, errors,
            (errors == 0) ? "PASS" : "FAIL",
            on_time, divisions
        );

        $finish;
    end

endmodule

`default_nettype wire


