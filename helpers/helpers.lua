-- ═══════════════════════════════════════════════════════════════
--   helpers.lua — Conky Minimal Complete
--   Auto-detects default network interface and GPU type.
--   Loaded via lua_load in conkyrc.
-- ═══════════════════════════════════════════════════════════════

local function shell(cmd)
    local h = io.popen(cmd .. " 2>/dev/null")
    if not h then return "" end
    local s = h:read("*a") or ""
    h:close()
    return s:gsub("\n+$", "")
end

local iface = os.getenv("IFACE") or ""

function conky_gpu_section()
    if os.execute("nvidia-smi > /dev/null 2>&1") then
        return conky_parse([[
${alignr}${color1}GPU:${color4}${exec nvidia-smi --query-gpu=gpu_name --format=csv,noheader} ${color}  ─┤   │   │
${alignr}${color1}GPU Temp ${color4}${execi 60 nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits} °C  ─┤   │   │
${alignr}${color1}GPU Util ${color4}${exec nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits} %   ─┤   │   │
${alignr}${color1}VRAM ${color4}${exec nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits} MB  ─┤   │   │
${alignr}${color1}GPU Power ${color4}${exec nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits} W  ─┤   │   │
]])
    else
        local temp_file = shell("ls /sys/class/drm/card*/device/hwmon/*/temp1_input 2>/dev/null | head -1")
        if temp_file ~= "" then
            return conky_parse([[
${alignr}${color1}GPU:${color4} AMD/Intel ${color}  ─┤   │   │
${alignr}${color1}GPU Temp ${color4}${execi 60 awk '{printf "%.0f",$1/1000}' ]] .. temp_file .. [[} °C  ─┤   │   │
]])
        else
            return conky_parse([[${alignr}${color1}GPU:${color4} N/A ${color}  ─┤   │   │
]])
        end
    end
end

function conky_net_section()
    if iface == "" then
        iface = shell("ip -o -4 route show default | awk '{print $5}' | head -1")
        if iface == "" then iface = "eth0" end
    end
    return conky_parse(string.format([[
${alignr}${offset -32}< ${addr %s} > Lan ─┤
${alignr}${offset -32}< ${downspeed %s} > ${totaldown %s} ▼ download ─┤
${alignr}${offset -32}< ${downspeedgraph %s 16,120 c44400 ba8d01} > ─┘    │
${alignr}${offset -32}< ${upspeed %s} > ${totalup %s}   ▲ upload ─┘
${alignr}${offset -62}< ${upspeedgraph %s 16,120 c44400 ba8d01} > ─┘
]], iface, iface, iface, iface, iface, iface, iface))
end