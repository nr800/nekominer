#!/usr/bin/env bash

# Get script directory for standalone testing
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Use HiveOS paths if available, otherwise use script directory
if [[ -z "$MINER_DIR" || -z "$CUSTOM_MINER" ]]; then
    MINER_PATH="$SCRIPT_DIR"
else
    MINER_PATH="$MINER_DIR/$CUSTOM_MINER"
fi

. "$MINER_PATH/h-manifest.conf"

# Read API port
API_PORT_FILE="$MINER_PATH/api_port.txt"
if [[ -f "$API_PORT_FILE" ]]; then
    API_PORT=$(cat "$API_PORT_FILE")
else
    API_PORT=45545
fi

# Fetch stats from API
API_RESPONSE=$(curl -s --connect-timeout 2 --max-time 5 "http://localhost:$API_PORT/" 2>/dev/null)

if [[ -z "$API_RESPONSE" ]] || ! echo "$API_RESPONSE" | jq -e . >/dev/null 2>&1; then
    khs=0
    stats="null"
    exit 1
fi

# Parse API response
miner_version=$(echo "$API_RESPONSE" | jq -r '.version // "unknown"')
uptime=$(echo "$API_RESPONSE" | jq -r '.uptime // 0')
algo=$(echo "$API_RESPONSE" | jq -r '.algo // "unknown"')

# Build per-GPU hashrate array and totals.
# The miner may report a non-GPU device (CPU) with id -1 and an empty bus_id.
# It contributes to the totals, but must NOT enter the per-GPU arrays: those
# stay aligned with the GPU-only temp/fan lists (nvidia-smi) and with HiveOS
# bus_numbers matching. Adding it as a fake GPU on bus 0 desyncs everything.
dev_count=$(echo "$API_RESPONSE" | jq '.devices | length')
bus_array="["
hr_list=()
total_hs=0
total_ac=0
total_rj=0
gpu_count=0

for ((i=0; i<dev_count; i++)); do
    dev=$(echo "$API_RESPONSE" | jq ".devices[$i]")
    # Keep the decimals. `cut -d. -f1` truncated every rate to its integer part,
    # which on btxv4 — one episode is ~5 s, so a card sits at ~0.24 H/s — made
    # every GPU read 0.
    hr=$(echo "$dev" | jq -r '.hashrate // 0')
    ac=$(echo "$dev" | jq -r '.accepted // 0')
    rj=$(echo "$dev" | jq -r '.rejected // 0')
    dev_id=$(echo "$dev" | jq -r '.id // 0')
    bus_id=$(echo "$dev" | jq -r '.bus_id // ""')

    # Totals include every device (GPUs + CPU); bash cannot add floats
    total_hs=$(awk "BEGIN {printf \"%.6f\", $total_hs + $hr}")
    total_ac=$((total_ac + ac))
    total_rj=$((total_rj + rj))

    # Per-GPU arrays: skip non-GPU devices (CPU: id -1 / empty bus_id)
    [[ "$dev_id" -lt 0 || -z "$bus_id" ]] && continue

    # Convert bus_id "01:00.0" to decimal
    bus_hex=$(echo "$bus_id" | grep -oP '^[0-9A-Fa-f]+' | head -1)
    bus_dec=$((16#${bus_hex:-0}))

    [[ $gpu_count -gt 0 ]] && bus_array+=","
    bus_array+="$bus_dec"
    hr_list+=("$hr")
    gpu_count=$((gpu_count + 1))
done

bus_array+="]"

# A whole btxv4 rig is ~1.9 H/s = 0.0019 kH/s, which every dashboard renders as
# zero, so report raw H/s below 1 kH/s. The MH/s-scale algos stay on kH/s
# exactly as before.
if awk "BEGIN {exit !($total_hs < 1000)}"; then
    hs_units="hs"; hs_div=1
else
    hs_units="khs"; hs_div=1000
fi

hs_array="["
for ((i=0; i<gpu_count; i++)); do
    [[ $i -gt 0 ]] && hs_array+=","
    hs_array+=$(awk "BEGIN {printf \"%.6f\", ${hr_list[$i]} / $hs_div}")
done
hs_array+="]"

# khs stays kH/s whatever hs_units says — HiveOS uses it for the rig total.
# 6 decimals so a sub-kH/s algo does not collapse to 0.000.
khs=$(awk "BEGIN {printf \"%.6f\", $total_hs / 1000}")

# Get GPU temperatures and fans from nvidia-smi
temps_array="["
fans_array="["

if command -v nvidia-smi &> /dev/null; then
    gpu_temps=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
    gpu_fans=$(nvidia-smi --query-gpu=fan.speed --format=csv,noheader,nounits 2>/dev/null)

    i=0
    while IFS= read -r temp; do
        [[ $i -gt 0 ]] && temps_array+=","
        [[ "$temp" == *"N/A"* || -z "$temp" ]] && temp="null"
        temps_array+="$temp"
        ((i++))
    done <<< "$gpu_temps"

    i=0
    while IFS= read -r fan; do
        [[ $i -gt 0 ]] && fans_array+=","
        [[ "$fan" == *"N/A"* || -z "$fan" ]] && fan="null"
        fans_array+="$fan"
        ((i++))
    done <<< "$gpu_fans"
else
    for ((i=0; i<gpu_count; i++)); do
        [[ $i -gt 0 ]] && temps_array+="," && fans_array+=","
        temps_array+="null"
        fans_array+="null"
    done
fi

temps_array+="]"
fans_array+="]"

# Build stats JSON for HiveOS
stats=$(jq -n \
    --argjson hs "$hs_array" \
    --arg hs_units "$hs_units" \
    --arg algo "$algo" \
    --argjson temp "$temps_array" \
    --argjson fan "$fans_array" \
    --argjson uptime "$uptime" \
    --arg ac "$total_ac" \
    --arg rj "$total_rj" \
    --argjson bus_numbers "$bus_array" \
    --arg ver "nekominer $miner_version" \
    '{hs: $hs, hs_units: $hs_units, algo: $algo, temp: $temp, fan: $fan, uptime: $uptime, ar: [$ac, $rj], bus_numbers: $bus_numbers, ver: $ver}')

[[ -z "$khs" ]] && khs=0
[[ -z "$stats" ]] && stats="null"
echo $stats | jq '.'
