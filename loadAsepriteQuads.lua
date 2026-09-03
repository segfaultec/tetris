local json = require "lib.json"

function loadAsepriteQuads(filename, image)

    local data, _ = lf.read(filename)
    data = json.decode(data)

    print(#data.meta.layers)

    local out_layers = {}

    for i,layer_data in ipairs(data.meta.layers) do
        local name = layer_data.name

        local in_layer = data.frames[name]

        local qdata = in_layer.frame
        local quad = lg.newQuad(
            qdata.x, qdata.y, qdata.w, qdata.h, image
        )

        local out_layer = {
            quad = quad,
            position = in_layer.spriteSourceSize
        }

        out_layers[name] = out_layer

    end

    return out_layers

end

return loadAsepriteQuads