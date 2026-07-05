# nekominer

CUDA GPU miner.

```
  /\_/\
 ( o.o )  nekominer
  > ^ <
```

## Supported Algorithms

| Algorithm | Coin | Dev Fee |
|-----------|------|---------|
| `btx` | BTX | 1% |
| `vecnohash` | VE (Vecno) | 1% |
| `bitweb` | BTE (Bitweb) | 1% |
| `equihash` | YEC (Ycash) | 2% |
| `exfer` | EXFER (Exfer) | 10% |
| `blake3` |  | 10% |

## Benchmarks

| Card | Algorithm | Coin | Hashrate | Core¹ | Mem² | Power |
|------|-----------|------|----------|-------|------|-------|
| RTX 3070 | `vecnohash` | VE (Vecno) | ~44 MH/s | 1710 +150 | stock | ~138 W |
| RTX 3070 | `bitweb` | BTE (Bitweb) | ~55.4 kH/s⁵ | 1560 +210 | +2000 | ~122 W |
| RTX 3070 | `equihash` | YEC (Ycash) | ~51.5 Sol/s | 1710 +150 | stock | ~147 W |
| RTX 3070 | `exfer` | EXFER | ~973 H/s | 1710 +150 | +2000 | ~119 W |
| RTX 3070 | `btx` | BTX | ~4.83 kH/s³ | 1710 +150 | +2000 | ~137 W |
| RTX 3070 | `blake3` | QADO | ~4.3 GH/s⁴ | — | — | — |

<sub>¹ Core = locked SM clock + offset (MHz): lock at 1710, add +150 — holds the clock at lower voltage (less power).</sub><br>
<sub>² Mem = GDDR6 transfer-rate offset: `stock` = no OC (boosts to ~6801), `+2000` = memory overclock.</sub><br>
<sub>³ BTX: 4.83 kH/s solve rate; sigma-scan ≈ 212 MNonce/s.</sub><br>
<sub>⁴ blake3 from earlier builds (OC not benchmarked).</sub><br>
<sub>⁵ bitweb: memory-bandwidth-bound — mem OC is the lever (~36 → 55 kH/s); core barely matters (+150 ≈ 0); 0 rejected.</sub><br>
<sub>Per-card values; RTX 3070 rows = average of 8× (driver 590).</sub>

## Usage

```bash
./nekominer -a <algo> -o <pool-url> -u <wallet>.<worker>
./nekominer --help
```

Choose `-a` from the table above. Per-algorithm pool URLs, connection examples, and
HiveOS flight sheets are in the sections below; pools shown with `ssl://` need the prefix.

**HiveOS:** create a **Custom Miner** flight sheet with installation URL
`https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz`
and pick the algorithm in *Extra config arguments*. Ready-made per-pool flight sheets are below. The os.dog package is at the bottom.

## Requirements

- NVIDIA GPU (Compute Capability 6.0+: Tesla P100 and newer)
- Linux x86_64
- NVIDIA Driver 525+

---

## VecnoHash — VE (Vecno)

```bash
./nekominer -a vecnohash -o ssl://ninjaraider.com:44701 -u %ADDRESS%.%WORKER%
```

<details>
<summary>VECNO ninjaraider nekominer</summary>

```json
{
  "name": "VECNO ninjaraider nekominer",
  "items": [{
    "coin": "VECNO",
    "miner": "custom",
    "miner_config": {
      "url": "ssl://ninjaraider.com:44701",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz",
      "user_config": "-a vecnohash"
    }
  }]
}
```
</details>

## Equihash — YEC (Ycash)

```bash
./nekominer -a equihash -o ssl://ninjaraider.com:44561 -u %ADDRESS%.%WORKER%
```

<details>
<summary>YEC ninjaraider nekominer</summary>

```json
{
  "name": "YEC ninjaraider nekominer",
  "items": [{
    "coin": "YEC",
    "miner": "custom",
    "miner_config": {
      "url": "ssl://ninjaraider.com:44561",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz",
      "user_config": "-a equihash"
    }
  }]
}
```
</details>

## Exfer — EXFER

Argon2id (m=64 MiB, t=2, p=1) memory-hard PoW.

```bash
./nekominer -a exfer -o ssl://ninjaraider.com:44913 -u %ADDRESS%.%WORKER%
./nekominer -a exfer -o ssl://exfer.luckypool.io:3336 -u %ADDRESS%.%WORKER%
```

| Pool | Connection |
|------|------------|
| ninjaraider.com | `ssl://ninjaraider.com:44913` or `ninjaraider.com:44912` |
| luckypool.io | `ssl://exfer.luckypool.io:3336` or `exfer.luckypool.io:3335` |

<details>
<summary>EXFER ninjaraider nekominer</summary>

```json
{
  "name": "EXFER ninjaraider nekominer",
  "items": [{
    "coin": "EXFER",
    "miner": "custom",
    "miner_config": {
      "url": "ssl://ninjaraider.com:44913",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz",
      "user_config": "-a exfer"
    }
  }]
}
```
</details>

<details>
<summary>EXFER luckypool nekominer</summary>

```json
{
  "name": "EXFER luckypool nekominer",
  "items": [{
    "coin": "EXFER",
    "miner": "custom",
    "miner_config": {
      "url": "ssl://exfer.luckypool.io:3336",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz",
      "user_config": "-a exfer"
    }
  }]
}
```
</details>

## BTX

`--pool-proto ninja` (ninjaraider, default) puts the worker in the address (`address.worker`); `minebtx` and `aria` take a bare address plus `--worker <name>`.

```bash
# ninjaraider.com — primary pool (ninja proto, default; worker goes in the address)
./nekominer -a btx -o ssl://ninjaraider.com:44921 -u <BTX_ADDRESS>.rig

# minebtx.com
./nekominer -a btx -o minebtx.com:3333 -u <BTX_ADDRESS> --worker rig --pool-proto minebtx

# bitminerpool.xyz (same minebtx protocol)
./nekominer -a btx -o bitminerpool.xyz:3333 -u <BTX_ADDRESS> --worker rig --pool-proto minebtx

# AriaBrain — mine on stratum.ariabrain.com:3940 (NOT pool.ariabrain.com)
./nekominer -a btx -o stratum.ariabrain.com:3940 -u <BTX_ADDRESS> --worker rig --pool-proto aria
```

| Pool | Connection | `--pool-proto` |
|------|------------|----------------|
| ninjaraider.com | `ssl://ninjaraider.com:44921` | `ninja` (default) |
| minebtx.com | `minebtx.com:3333` | `minebtx` |
| bitminerpool.xyz | `bitminerpool.xyz:3333` | `minebtx` |
| AriaBrain | `stratum.ariabrain.com:3940` | `aria` |

<details>
<summary>BTX ninjaraider nekominer</summary>

```json
{
  "name": "BTX ninjaraider nekominer",
  "items": [{
    "coin": "BTX",
    "miner": "custom",
    "miner_config": {
      "url": "ssl://ninjaraider.com:44921",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz",
      "user_config": "-a btx"
    }
  }]
}
```
</details>

<details>
<summary>BTX minebtx nekominer</summary>

```json
{
  "name": "BTX minebtx nekominer",
  "items": [{
    "coin": "BTX",
    "miner": "custom",
    "miner_config": {
      "url": "minebtx.com:3333",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz",
      "user_config": "-a btx --pool-proto minebtx"
    }
  }]
}
```
</details>

<details>
<summary>BTX bitminerpool nekominer</summary>

```json
{
  "name": "BTX bitminerpool nekominer",
  "items": [{
    "coin": "BTX",
    "miner": "custom",
    "miner_config": {
      "url": "bitminerpool.xyz:3333",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz",
      "user_config": "-a btx --pool-proto minebtx"
    }
  }]
}
```
</details>

<details>
<summary>BTX ariapool nekominer</summary>

```json
{
  "name": "BTX ariapool nekominer",
  "items": [{
    "coin": "BTX",
    "miner": "custom",
    "miner_config": {
      "url": "stratum.ariabrain.com:3940",
      "miner": "nekominer-hiveos",
      "template": "%WAL%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz",
      "user_config": "-a btx --pool-proto aria --worker %WORKER%"
    }
  }]
}
```
</details>

## Bitweb — BTE

Argon2id (m=1 MiB, t=3, p=1) memory-hard PoW.

```bash
./nekominer -a bitweb -o ssl://mining.bitwebcore.net:3032 -u %ADDRESS%.%WORKER%
```

<details>
<summary>BTE bitwebcore nekominer</summary>

```json
{
  "name": "BTE bitwebcore nekominer",
  "items": [{
    "coin": "BTE",
    "miner": "custom",
    "miner_config": {
      "url": "ssl://mining.bitwebcore.net:3032",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-hiveos-0.11.36.tar.gz",
      "user_config": "-a bitweb"
    }
  }]
}
```
</details>

## Downloads

See [Releases](../../releases).

- **os.dog package:** [`nekominer-osdog-0.11.36.tar.gz`](https://github.com/nr800/nekominer/releases/download/v0.11.36/nekominer-osdog-0.11.36.tar.gz)
