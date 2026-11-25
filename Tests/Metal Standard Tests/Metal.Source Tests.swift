import Metal_Standard
import Testing

enum `Metal Tests` {}

extension `Metal Tests` {
    @Suite
    struct Source {
        @Test
        func `A kernel is written with its attributes, and operands in parentheses`() {
            let sum = Metal.Expression.binary(.binary(.name("a"), .plus, .uint(1)), .times, .float(0x3F80_0000))
            let kernel = Metal.Function(
                role: .kernel,
                result: .void,
                name: "run",
                parameters: [
                    .init(.pointer(.uint, .device, constant: true), "b0", .buffer(0)), .init(.vector(.uint, 2), "id", .threadPositionInGrid),
                ],
                body: [
                    .pragma("fp contract(off)"), .declare(.uint, "a", .element(.name("b0"), .member(.name("id"), "x"))),
                    .if(.binary(.name("a"), .equal, .uint(0)), [.return(nil)], else: [.evaluate(.call("use", [sum]))]),
                ]
            )
            #expect(
                Metal.Source([.function(kernel)]).text == """
                    kernel void run(device const uint * b0 [[buffer(0)]], uint2 id [[thread_position_in_grid]]) {
                        #pragma METAL fp contract(off)
                        uint a = b0[id.x];
                        if (a == 0u) {
                            return;
                        } else {
                            use((a + 1u) * as_type<float>(1065353216u));
                        }
                    }

                    """
            )
        }
    }
}
