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

        @Test
        func `A vertex and a fragment stage are written with what one hands the other, a texture and a sampler`() {
            let handed = Metal.Structure(
                name: "Handed",
                members: [.init(.vector(.float, 4), "position", at: .position), .init(.uint, "shape", at: .place(0, flat: true))]
            )
            let corner = Metal.Function(
                role: .vertex,
                result: .structure("Handed"),
                name: "corner",
                parameters: [.init(.uint, "vertex", .vertexID), .init(.uint, "instance", .instanceID)],
                body: [.declare(.structure("Handed"), "out", nil), .return(.name("out"))]
            )
            let pixel = Metal.Function(
                role: .fragment,
                result: .vector(.float, 4),
                name: "pixel",
                parameters: [
                    .init(.structure("Handed"), "handed", .stageIn), .init(.texture(.float, written: false), "sheet", .texture(0)),
                    .init(.sampler, "between", .sampler(0)),
                ],
                body: [.return(.call("sheet.sample", [.name("between"), .member(.member(.name("handed"), "position"), "xy")]))]
            )
            #expect(
                Metal.Source([.structure(handed), .function(corner), .function(pixel)]).text == """
                    struct Handed {
                        float4 position [[position]];
                        uint shape [[user(locn0), flat]];
                    };

                    vertex Handed corner(uint vertex [[vertex_id]], uint instance [[instance_id]]) {
                        Handed out;
                        return out;
                    }

                    fragment float4 pixel(Handed handed [[stage_in]], texture2d<float> sheet [[texture(0)]], sampler between [[sampler(0)]]) {
                        return sheet.sample(between, handed.position.xy);
                    }

                    """
            )
        }
    }
}
