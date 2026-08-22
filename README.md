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
| `btxv4` (alias `btx`) | BTX | 2%, **0% on ninjaraider** |
| `vecnohash` | VE (Vecno) | 1% |
| `equihash` | YEC (Ycash) | 2% |
| `exfer` | EXFER (Exfer) | 10% |

<details>
<summary>Deprecated algorithms</summary>

| Algorithm | Coin | Dev Fee |
|-----------|------|---------|
| `blake3` |  | 10% |

</details>

## Benchmarks

| Card | Algorithm | Coin | Hashrate | Core¹ | Mem² | Power |
|------|-----------|------|----------|-------|------|-------|
| RTX 3070 | `vecnohash` | VE (Vecno) | ~44 MH/s | 1710 +150 | stock | ~138 W |
| RTX 3070 | `equihash` | YEC (Ycash) | ~51.5 Sol/s | 1710 +150 | stock | ~147 W |
| RTX 3070 | `exfer` | EXFER | ~973 H/s | 1710 +150 | +2000 | ~119 W |

<sub>¹ Core = locked SM clock + offset (MHz): lock at 1710, add +150 — holds the clock at lower voltage (less power).</sub><br>
<sub>² Mem = GDDR6 transfer-rate offset: `stock` = no OC (boosts to ~6801), `+2000` = memory overclock.</sub><br>
<sub>Per-card values; RTX 3070 rows = average of 8× (driver 590).</sub>

<details>
<summary>Deprecated algorithms</summary>

| Card | Algorithm | Coin | Hashrate | Core | Mem | Power |
|------|-----------|------|----------|------|-----|-------|
| RTX 3070 | `blake3` | QADO | ~4.3 GH/s | — | — | — |

<sub>blake3 from earlier builds (OC not benchmarked).</sub>

</details>

## Usage

```bash
./nekominer -a <algo> -o <pool-url> -u <wallet>.<worker>
./nekominer --help
```

Choose `-a` from the table above. Per-algorithm pool URLs, connection examples, and
HiveOS flight sheets are in the sections below; pools shown with `ssl://` need the prefix.

**HiveOS:** create a **Custom Miner** flight sheet with installation URL
`https://github.com/nr800/nekominer/releases/download/v0.13.1/nekominer-hiveos-0.13.1.tar.gz`
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
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.13.1/nekominer-hiveos-0.13.1.tar.gz",
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
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.13.1/nekominer-hiveos-0.13.1.tar.gz",
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
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.13.1/nekominer-hiveos-0.13.1.tar.gz",
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
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.13.1/nekominer-hiveos-0.13.1.tar.gz",
      "user_config": "-a exfer"
    }
  }]
}
```
</details>

## BTX — btxv4

`btxv4` is the post-185'000 fork; **`btx` is an alias for it** — the pre-fork v3 PoW is gone.

`--pool-proto` defaults to `auto`, which probes the pool, so it can normally be omitted.
`ninja` (ninjaraider) puts the worker in the address (`address.worker`); `minebtx`
(Stratum v1 + `matmul_meta`) takes a bare address plus `--worker <name>`.

```bash
# ninjaraider.com
./nekominer -a btxv4 -o btxv4.ninjaraider.com:44950 -u <BTX_ADDRESS>.rig

# btxbyronbay.com
./nekominer -a btxv4 -o stratum.btxbyronbay.com:3335 -u <BTX_ADDRESS> --worker rig

# diffpool.xyz
./nekominer -a btxv4 -o btx.diffpool.xyz:3333 -u <BTX_ADDRESS> --worker rig
```

<details>
<summary>BTX ninjaraider nekominer</summary>

```json
{
  "name": "BTX ninjaraider nekominer",
  "items": [{
    "coin": "BTX",
    "miner": "custom",
    "miner_config": {
      "url": "btxv4.ninjaraider.com:44950",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.13.1/nekominer-hiveos-0.13.1.tar.gz",
      "user_config": "-a btxv4"
    }
  }]
}
```
</details>

<details>
<summary>BTX byronbay nekominer</summary>

```json
{
  "name": "BTX byronbay nekominer",
  "items": [{
    "coin": "BTX",
    "miner": "custom",
    "miner_config": {
      "url": "stratum.btxbyronbay.com:3335",
      "miner": "nekominer-hiveos",
      "template": "%WAL%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.13.1/nekominer-hiveos-0.13.1.tar.gz",
      "user_config": "-a btxv4 --worker %WORKER%"
    }
  }]
}
```
</details>

<details>
<summary>BTX diffpool nekominer</summary>

```json
{
  "name": "BTX diffpool nekominer",
  "items": [{
    "coin": "BTX",
    "miner": "custom",
    "miner_config": {
      "url": "btx.diffpool.xyz:3333",
      "miner": "nekominer-hiveos",
      "template": "%WAL%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.13.1/nekominer-hiveos-0.13.1.tar.gz",
      "user_config": "-a btxv4 --worker %WORKER%"
    }
  }]
}
```
</details>

## Downloads

See [Releases](../../releases).

- **os.dog package:** [`nekominer-osdog-0.13.1.tar.gz`](https://github.com/nr800/nekominer/releases/download/v0.13.1/nekominer-osdog-0.13.1.tar.gz)
