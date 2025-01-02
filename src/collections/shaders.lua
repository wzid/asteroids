--- Gaussian blur kernel generator
---@param radius number the size of the kernel (must be odd)
---@return table the kernel
local function gen_gaussian(radius)
    -- nvidia uses sigma = radius / 3.0
    -- https://stackoverflow.com/questions/17841098/gaussian-blur-standard-deviation-radius-and-kernel-size
    -- https://developer.nvidia.com/gpugems/gpugems3/part-vi-gpu-computing/chapter-40-incremental-computation-gaussian
    local sigma = radius / 3.0;

    local kernel = {}
    local sum = 0
    for i = 1, radius do
        local x = i - (radius + 1) / 2
        kernel[i] = math.exp(-x * x / (2 * sigma * sigma))
        sum = sum + kernel[i]
    end
    -- normalize the kernel
    for i = 1, radius do
        kernel[i] = kernel[i] / sum
    end
    return kernel
end


return {gen_gaussian = gen_gaussian}