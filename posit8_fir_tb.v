`timescale 1ns/1ps

module posit8_fir_tb;

    reg [7:0] a, b;
    wire [7:0] add_y;
    wire [7:0] mul_y;

    reg clk;
    reg rst;
    reg [7:0] x_in;
    wire [7:0] y_out;

    integer errors;
    integer tests;

    posit8_add ADD_DUT(
        .a(a),
        .b(b),
        .y(add_y)
    );

    posit8_mul MUL_DUT(
        .a(a),
        .b(b),
        .y(mul_y)
    );

    fir_filter_posit FIR_DUT(
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    always #5 clk = ~clk;

    task check_add;
        input [7:0] aa;
        input [7:0] bb;
        input [7:0] expected;
        begin
            a = aa;
            b = bb;
            #2;
            tests = tests + 1;

            if (add_y !== expected) begin
                errors = errors + 1;
                $display(
                    "FAIL ADD %02h + %02h Expected=%02h Got=%02h",
                    aa, bb, expected, add_y
                );
            end
            else begin
                $display(
                    "PASS ADD %02h + %02h = %02h",
                    aa, bb, add_y
                );
            end
        end
    endtask

    task check_mul;
        input [7:0] aa;
        input [7:0] bb;
        input [7:0] expected;
        begin
            a = aa;
            b = bb;
            #2;
            tests = tests + 1;

            if (mul_y !== expected) begin
                errors = errors + 1;
                $display(
                    "FAIL MUL %02h * %02h Expected=%02h Got=%02h",
                    aa, bb, expected, mul_y
                );
            end
            else begin
                $display(
                    "PASS MUL %02h * %02h = %02h",
                    aa, bb, mul_y
                );
            end
        end
    endtask

    initial begin

        clk = 0;
        rst = 0;
        x_in = 0;
        a = 0;
        b = 0;

        errors = 0;
        tests = 0;

        $display("--------------------------------");
        $display("POSIT ARITHMETIC TEST START");
        $display("--------------------------------");

        // ADDITION TESTS

        check_add(8'h40, 8'h40, 8'h60);
        check_add(8'h40, 8'h60, 8'h68);
        check_add(8'h40, 8'hC0, 8'h00);
        check_add(8'h00, 8'h60, 8'h60);
        check_add(8'h80, 8'h40, 8'h80);

        // MULTIPLICATION TESTS

        check_mul(8'h40, 8'h40, 8'h40);
        check_mul(8'h40, 8'h60, 8'h60);
        check_mul(8'h60, 8'h60, 8'h70);
        check_mul(8'hC0, 8'h60, 8'hA0);
        check_mul(8'h80, 8'h40, 8'h80);

        // FIR RESET TEST

        @(negedge clk);
        rst = 1;
        x_in = 0;

        @(negedge clk);
        #1;

        tests = tests + 1;

        if (y_out !== 8'h00) begin
            errors = errors + 1;
            $display("FAIL RESET");
        end
        else begin
            $display("PASS RESET");
        end

        // FIR IMPULSE RESPONSE TEST

        rst = 0;
        x_in = 8'h40;

        @(negedge clk);
        #1;
        tests = tests + 1;

        if (y_out !== 8'h40) begin
            errors = errors + 1;
            $display("FAIL FIR[0] Expected=40 Got=%02h", y_out);
        end
        else begin
            $display("PASS FIR[0] = %02h", y_out);
        end

        x_in = 8'h00;

        @(negedge clk);
        #1;
        tests = tests + 1;

        if (y_out !== 8'h60) begin
            errors = errors + 1;
            $display("FAIL FIR[1] Expected=60 Got=%02h", y_out);
        end
        else begin
            $display("PASS FIR[1] = %02h", y_out);
        end

        @(negedge clk);
        #1;
        tests = tests + 1;

        if (y_out !== 8'h60) begin
            errors = errors + 1;
            $display("FAIL FIR[2] Expected=60 Got=%02h", y_out);
        end
        else begin
            $display("PASS FIR[2] = %02h", y_out);
        end

        @(negedge clk);
        #1;
        tests = tests + 1;

        if (y_out !== 8'h40) begin
            errors = errors + 1;
            $display("FAIL FIR[3] Expected=40 Got=%02h", y_out);
        end
        else begin
            $display("PASS FIR[3] = %02h", y_out);
        end

        @(negedge clk);
        #1;
        tests = tests + 1;

        if (y_out !== 8'h00) begin
            errors = errors + 1;
            $display("FAIL FIR[4] Expected=00 Got=%02h", y_out);
        end
        else begin
            $display("PASS FIR[4] = %02h", y_out);
        end

        $display("--------------------------------");
        $display("TOTAL TESTS = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED");

        $display("--------------------------------");

        $finish;
    end

endmodule