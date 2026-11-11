
`timescale 1ns/1ps

module posit8_exhaustive_tb;

    reg  [7:0] a, b;
    wire [7:0] add_y, mul_y;

    reg [7:0] expected_add, expected_mul;

    integer i, j;
    integer add_errors, mul_errors;
    integer add_checked, mul_checked;
    integer shown_errors;

    real value_a, value_b;

    posit8_add ADD_DUT (
        .a(a),
        .b(b),
        .y(add_y)
    );

    posit8_mul MUL_DUT (
        .a(a),
        .b(b),
        .y(mul_y)
    );

    // ------------------------------------------------
    // Calculate powers of two.
    // ------------------------------------------------

    function real power_of_two;
        input integer exponent;
        integer n;
        real result;
        begin
            result = 1.0;

            if (exponent >= 0) begin
                for (n = 0; n < exponent; n = n + 1)
                    result = result * 2.0;
            end
            else begin
                for (n = 0; n < -exponent; n = n + 1)
                    result = result / 2.0;
            end

            power_of_two = result;
        end
    endfunction

    // ------------------------------------------------
    // Independent Posit<8,0> decoder.
    // ------------------------------------------------

    function real ref_decode;
        input [7:0] p;

        reg [7:0] mag;
        reg regime_bit;

        integer idx;
        integer run_length;
        integer k;
        integer j;

        real fraction;
        real weight;
        real result;

        begin
            ref_decode = 0.0;

            if ((p == 8'h00) || (p == 8'h80)) begin
                ref_decode = 0.0;
            end
            else begin

                if (p[7])
                    mag = (~p) + 8'd1;
                else
                    mag = p;

                regime_bit = mag[6];
                idx = 6;
                run_length = 0;

                while ((idx >= 0) &&
                       (mag[idx] == regime_bit)) begin
                    run_length = run_length + 1;
                    idx = idx - 1;
                end

                if (idx >= 0)
                    idx = idx - 1;

                if (regime_bit)
                    k = run_length - 1;
                else
                    k = -run_length;

                fraction = 0.0;
                weight = 0.5;

                for (j = idx; j >= 0; j = j - 1) begin
                    if (mag[j])
                        fraction = fraction + weight;

                    weight = weight / 2.0;
                end

                result = power_of_two(k) * (1.0 + fraction);

                if (p[7])
                    result = -result;

                ref_decode = result;
            end
        end
    endfunction

    // ------------------------------------------------
    // Independent Posit<8,0> encoder.
    // Round to nearest; ties to even encoding LSB.
    // ------------------------------------------------

    function [7:0] ref_encode;
        input real input_value;

        integer code;
        integer best_code;

        real magnitude;
        real candidate;
        real distance;
        real best_distance;

        reg negative;

        begin
            ref_encode = 8'h00;

            if (input_value == 0.0) begin
                ref_encode = 8'h00;
            end
            else begin

                negative = (input_value < 0.0);

                if (negative)
                    magnitude = -input_value;
                else
                    magnitude = input_value;

               // Include zero as a rounding candidate.
best_code = 0;
best_distance = magnitude;

                // Search all positive finite posit values.
                for (code = 1; code <= 127; code = code + 1) begin

                    candidate = ref_decode(code[7:0]);

                    if (candidate >= magnitude)
                        distance = candidate - magnitude;
                    else
                        distance = magnitude - candidate;

                    if ((distance < best_distance) ||
                        ((distance == best_distance) &&
                         ((code % 2) == 0) &&
                         ((best_code % 2) != 0))) begin

                        best_distance = distance;
                        best_code = code;

                    end
                end

                // Saturation is naturally handled by the nearest
                // representable value search.

                if (negative)
                    ref_encode = (~best_code) + 8'd1;
                else
                    ref_encode = best_code[7:0];

            end
        end
    endfunction

    // ------------------------------------------------
    // Reference addition.
    // ------------------------------------------------

    function [7:0] ref_add;
        input [7:0] aa, bb;

        real result;
        begin
            if ((aa == 8'h80) || (bb == 8'h80)) begin
                ref_add = 8'h80;
            end
            else begin
                result = ref_decode(aa) + ref_decode(bb);
                ref_add = ref_encode(result);
            end
        end
    endfunction

    // ------------------------------------------------
    // Reference multiplication.
    // ------------------------------------------------

    function [7:0] ref_mul;
        input [7:0] aa, bb;

        real result;
        begin
            if ((aa == 8'h80) || (bb == 8'h80)) begin
                ref_mul = 8'h80;
            end
            else begin
                result = ref_decode(aa) * ref_decode(bb);
                ref_mul = ref_encode(result);
            end
        end
    endfunction

    // ------------------------------------------------
    // Exhaustive testing.
    // ------------------------------------------------

    initial begin

        a = 8'h00;
        b = 8'h00;

        add_errors = 0;
        mul_errors = 0;

        add_checked = 0;
        mul_checked = 0;

        shown_errors = 0;

        $display("----------------------------------------");
        $display("POSIT<8,0> EXHAUSTIVE ARITHMETIC TEST");
        $display("----------------------------------------");

        for (i = 0; i < 256; i = i + 1) begin

if ((i % 16) == 0)
    $display("Testing input group %0d / 255", i);

            for (j = 0; j < 256; j = j + 1) begin

                a = i;
                b = j;

                #1;

                // Addition check.
                expected_add = ref_add(a, b);
                add_checked = add_checked + 1;

                if (add_y !== expected_add) begin

                    add_errors = add_errors + 1;

                    if (shown_errors < 20) begin
                        $display(
                            "ADD ERROR: A=%h B=%h DUT=%h REF=%h",
                            a, b, add_y, expected_add
                        );

                        shown_errors = shown_errors + 1;
                    end
                end

                // Multiplication check.
                expected_mul = ref_mul(a, b);
                mul_checked = mul_checked + 1;

                if (mul_y !== expected_mul) begin

                    mul_errors = mul_errors + 1;

                    if (shown_errors < 20) begin
                        $display(
                            "MUL ERROR: A=%h B=%h DUT=%h REF=%h",
                            a, b, mul_y, expected_mul
                        );

                        shown_errors = shown_errors + 1;
                    end
                end

            end
        end

        // ------------------------------------------------
        // Final report.
        // ------------------------------------------------

        $display("");
        $display("----------------------------------------");
        $display("EXHAUSTIVE TEST RESULTS");
        $display("----------------------------------------");

        $display("Addition pairs tested      = %0d", add_checked);
        $display("Addition errors            = %0d", add_errors);

        $display("Multiplication pairs tested = %0d", mul_checked);
        $display("Multiplication errors       = %0d", mul_errors);

        if ((add_errors == 0) && (mul_errors == 0)) begin
            $display("");
            $display("ALL EXHAUSTIVE TESTS PASSED");
        end
        else begin
            $display("");
            $display("EXHAUSTIVE TEST FAILED");
        end

        $display("----------------------------------------");

        $finish;

    end

endmodule
