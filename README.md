# Conky Minimal Complete

**AlagrApHY Studios** — Tree-style system monitor for Conky 1.10+.

Right-aligned, box-drawing tree layout. Pink/orange palette on transparent
background. All system sections cascading vertically with `┐┘┤─` connectors.

---

## Sections

| Section      | Details                                       |
|--------------|-----------------------------------------------|
| Clock        | Date, time                                    |
| System       | OS, kernel, uptime                            |
| Processor    | CPU model, per-core usage, load, top procs    |
| Graphics     | GPU name, temp, util, VRAM, power (auto-detect) |
| Memory       | Usage %, bar, top consumers                   |
| Disk         | Read/write IO, /root and /home usage bars     |
| Network      | Hostname, WAN IP, LAN IP, up/down graphs     |

---

## Quick Install

```bash
chmod +x install.sh
./install.sh
```

The installer copies `conkyrc` to `~/.conkyrc`, the Lua helper to
`~/.config/conky/minimal/helpers/`, and launches conky.

---

## Auto-Detection

**Network:** The default route interface is detected at runtime via
`helpers.lua`. Override with the `IFACE` environment variable:

```bash
IFACE=wlan0 conky -c ~/.conkyrc
```

**GPU:** NVIDIA (via `nvidia-smi`) gets full stats. AMD/Intel gets
temperature from `sysfs`. No GPU → `N/A`.

---

## Customization

Edit `conkyrc` to:

- Change `maximum_width` / `minimum_height`
- Adjust `gap_x` / `gap_y` for positioning
- Swap `font`, colors (`color0`–`color4`)
- Remove unused CPU core lines (cpu0–cpu9)

---

## Requirements

- Conky 1.10+ (Lua config syntax)
- `ip` (from iproute2) for network detection
- `curl` for WAN IP
- `nvidia-smi` (optional, for NVIDIA GPU stats)
- A monospace font (uses system `monospace` by default)