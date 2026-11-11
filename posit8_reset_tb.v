
`timescale 1ns/1ps

module posit8_reset_tb;

    reg clk;
    reg rst;
    reg [7:0] x_in;

    wire [7:0] y_out;

    integer errors;

    // FIR design under test
    fir_filter_posit DUT (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Output checking task
    task check_output;
        input [7:0] expected;
        input integer test_number;
        begin
            if (y_out !== expected) begin
                $display(
                    "FAIL: Test %0d Expected=%h Actual=%h",
                    test_number, expected, y_out
                );
                errors = errors + 1;
            end
            else begin
                $display(
                    "PASS: Test %0d Output=%h",
                    test_number, y_out
                );
            end
        end
    endtask

    initial begin

        errors = 0;
        rst = 1;
        x_in = 8'h00;

        $display("--------------------------------");
        $display("POSIT FIR RESET TEST STARTED");
        $display("--------------------------------");

        // TEST 1: Initial reset
        repeat (2) @(negedge clk);
        #1;
        check_output(8'h00, 1);

        // Release reset
        rst = 0;

        // TEST 2: Apply impulse input
        @(negedge clk);
        x_in = 8'h40;

        @(posedge clk);
        #1;
        check_output(8'h40, 2);

        // TEST 3: Apply zero input
        @(negedge clk);
        x_in = 8'h00;

        @(posedge clk);
        #1;
        check_output(8'h60, 3);

        // TEST 4: Assert reset during operation
        #2;
        rst = 1;
        #1;
        check_output(8'h00, 4);

        // TEST 5: Keep reset active
        repeat (2) @(negedge clk);
        #1;
        check_output(8'h00, 5);

        // Release reset
        rst = 0;

        // TEST 6: Verify previous samples are cleared
        @(negedge clk);
        x_in = 8'h00;

        @(posedge clk);
        #1;
        check_output(8'h00, 6);

        // TEST 7: Apply a new impulse after reset
        @(negedge clk);
        x_in = 8'h40;

        @(posedge clk);
        #1;
        check_output(8'h40, 7);

        // TEST 8: First delayed impulse output
        @(negedge clk);
        x_in = 8'h00;

        @(posedge clk);
        #1;
        check_output(8'h60, 8);

        // TEST 9: Second delayed impulse output
        @(negedge clk);
        @(posedge clk);
        #1;
        check_output(8'h60, 9);

        // TEST 10: Third delayed impulse output
        @(negedge clk);
        @(posedge clk);
        #1;
        check_output(8'h40, 10);

        // TEST 11: Final output
        @(negedge clk);
        @(posedge clk);
        #1;
        check_output(8'h00, 11);

        // Final report
        $display("--------------------------------");
        $display("RESET TEST RESULTS");
        $display("Tests performed = 11");
        $display("Errors          = %0d", errors);

        if (errors == 0)
            $display("ALL RESET TESTS PASSED");
        else
            $display("RESET TEST FAILED");

        $display("--------------------------------");

        $finish;

    end

endmodule
