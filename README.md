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
| `quantus` | Quantus (QTC) | 1% |
| `btxv4` (alias `btx`) | BTX | 2%, **0% on ninjaraider** |
| `equihash192_7` | Ycash (YEC) | 2% |
| `equihash144_5` | NULL | 2% |
| `exfer` | Exfer (EXFER) | 10% |
| `poscan` | Numen (NUMN) | 10% |
| `cmfd` | CMFD | 2% |
| `vela` | Vela (VELA) | 3% |

<details>
<summary>Deprecated algorithms</summary>

| Algorithm | Coin | Last supported |
|-----------|------|----------------|
| `blake3` | Qado (QADO) | [v0.11.41](../../releases/tag/v0.11.41) |
| `vecnohash` | Vecno (VE) | [v0.17.0](../../releases/tag/v0.17.0) |

</details>

<details>
<summary>Benchmarks</summary>

| Card | Algorithm | Coin | Hashrate | Core¹ | Mem² | Power |
|------|-----------|------|----------|-------|------|-------|
| RTX 3070 | `equihash192_7` | Ycash (YEC) | ~51.5 Sol/s | 1710 +150 | stock | ~147 W |
| RTX 3070 | `exfer` | Exfer (EXFER) | ~973 H/s | 1710 +150 | +2000 | ~119 W |

<sub>¹ Core = locked SM clock + offset (MHz): lock at 1710, add +150 — holds the clock at lower voltage (less power).</sub><br>
<sub>² Mem = GDDR6 transfer-rate offset: `stock` = no OC (boosts to ~6801), `+2000` = memory overclock.</sub><br>
<sub>Per-card values; RTX 3070 rows = average of 8× (driver 590).</sub>

<details>
<summary>Deprecated algorithms</summary>

| Card | Algorithm | Coin | Hashrate | Core | Mem | Power |
|------|-----------|------|----------|------|-----|-------|
| RTX 3070 | `blake3` | Qado (QADO) | ~4.3 GH/s | — | — | — |
| RTX 3070 | `vecnohash` | Vecno (VE) | ~44 MH/s | 1710 +150 | stock | ~138 W |

<sub>blake3 from earlier builds (OC not benchmarked).</sub>

</details>

</details>

## Usage

```bash
./nekominer -a <ALGO> -o <POOL> -u <ADDRESS>.<WORKER>
./nekominer --help
```

Choose `-a` from the table above. Per-algorithm pool URLs, connection examples, and
HiveOS flight sheets are in the sections below; pools shown with `ssl://` need the prefix.

**HiveOS:** create a **Custom Miner** flight sheet with installation URL
`https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz`
and pick the algorithm in *Extra config arguments*. Ready-made per-pool flight sheets are below. The os.dog package is at the bottom.

## Requirements

- NVIDIA GPU (Compute Capability 6.0+: Tesla P100 and newer)
- Linux x86_64
- NVIDIA Driver 525+

---

## Quantus (QTC)

```bash
# kryptex.network
./nekominer -a quantus -o ssl://qtc.kryptex.network:8049 -u <ADDRESS>.<WORKER>
```

<details>
<summary>QTC kryptex nekominer</summary>

```json
{
  "name": "QTC kryptex nekominer",
  "items": [{
    "coin": "QTC",
    "miner": "custom",
    "miner_config": {
      "url": "ssl://qtc.kryptex.network:8049",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a quantus"
    }
  }]
}
```
</details>

## Equihash (192,7) — Ycash (YEC)

```bash
./nekominer -a equihash192_7 -o ssl://ninjaraider.com:44561 -u <ADDRESS>.<WORKER>
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
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a equihash192_7"
    }
  }]
}
```
</details>

## Equihash (144,5) — NULL

`-u` takes a `null1…` address.

```bash
# ninjaraider.com
./nekominer -a equihash144_5 -o ssl://ninjaraider.com:44981 -u <ADDRESS>.<WORKER>

# pool.ariabrain.com
./nekominer -a equihash144_5 -o 159.69.194.46:3353 -u <ADDRESS>.<WORKER>
```

<details>
<summary>NULL ninjaraider nekominer</summary>

```json
{
  "name": "NULL ninjaraider nekominer",
  "items": [{
    "coin": "NULL",
    "miner": "custom",
    "miner_config": {
      "url": "ssl://ninjaraider.com:44981",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a equihash144_5"
    }
  }]
}
```
</details>

## Exfer (EXFER)

Argon2id (m=64 MiB, t=2, p=1) memory-hard PoW.

```bash
./nekominer -a exfer -o ssl://ninjaraider.com:44913 -u <ADDRESS>.<WORKER>
./nekominer -a exfer -o ssl://exfer.luckypool.io:3336 -u <ADDRESS>.<WORKER>
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
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
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
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a exfer"
    }
  }]
}
```
</details>

## Poscan — Numen (NUMN)

```bash
./nekominer -a poscan -o ssl://numen.ninjaraider.com:44961 -u <ADDRESS>.<WORKER>
```

<details>
<summary>NUMN ninjaraider nekominer</summary>

```json
{
  "name": "NUMN ninjaraider nekominer",
  "items": [{
    "coin": "NUMN",
    "miner": "custom",
    "miner_config": {
      "url": "ssl://numen.ninjaraider.com:44961",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a poscan"
    }
  }]
}
```
</details>

## CMFD

On first start the miner downloads the model (~6.4 GB), so the first launch takes a while
and needs that much free disk space. `-u` takes the 64-hex payout address.

```bash
# pool.ariabrain.com
./nekominer -a cmfd -o "cmfd+tls://159.69.194.46:29445?pin=9dfb51083f287726117f689f87bc7a878792efcca58ca8b6f6e7c05ac5d152e9" -u <ADDRESS> --worker <WORKER>

# cmfd-pool.online
./nekominer -a cmfd -o "cmfd+tls://109.199.124.187:29465?pin=ebe88f5e05f3a222208d551d05b6d39057b64ce8239ba7a708d487e15ac711be" -u <ADDRESS> --worker <WORKER>
```

<details>
<summary>CMFD ariabrain nekominer</summary>

```json
{
  "name": "CMFD ariabrain nekominer",
  "items": [{
    "coin": "CMFD",
    "miner": "custom",
    "miner_config": {
      "url": "cmfd+tls://159.69.194.46:29445?pin=9dfb51083f287726117f689f87bc7a878792efcca58ca8b6f6e7c05ac5d152e9",
      "miner": "nekominer-hiveos",
      "template": "%WAL%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a cmfd --worker %WORKER_NAME%"
    }
  }]
}
```
</details>

<details>
<summary>CMFD cmfd-pool nekominer</summary>

```json
{
  "name": "CMFD cmfd-pool nekominer",
  "items": [{
    "coin": "CMFD",
    "miner": "custom",
    "miner_config": {
      "url": "cmfd+tls://109.199.124.187:29465?pin=ebe88f5e05f3a222208d551d05b6d39057b64ce8239ba7a708d487e15ac711be",
      "miner": "nekominer-hiveos",
      "template": "%WAL%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a cmfd --worker %WORKER_NAME%"
    }
  }]
}
```
</details>

## Vela (VELA)

On first start the miner downloads the model (~1.2 GB), so the first launch takes a while
and needs that much free disk space. `-u` takes a `vela1…` address.

```bash
# pool.ariabrain.com
./nekominer -a vela -o http://159.69.194.46:3349 -u <ADDRESS>.<WORKER>
```

<details>
<summary>VELA ariabrain nekominer</summary>

```json
{
  "name": "VELA ariabrain nekominer",
  "items": [{
    "coin": "VELA",
    "miner": "custom",
    "miner_config": {
      "url": "http://159.69.194.46:3349",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a vela"
    }
  }]
}
```
</details>

## BTX — btxv4

`btxv4` is the post-185'000 fork; **`btx` is an alias for it** — the pre-fork v3 PoW is gone.

`--pool-proto` defaults to `auto`, which probes the pool, so it can normally be omitted.
On every pool the worker goes after the address, `<ADDRESS>.<WORKER>`
(`--worker <WORKER>` does the same).

```bash
# ninjaraider.com
./nekominer -a btxv4 -o btxv4.ninjaraider.com:44950 -u <ADDRESS>.<WORKER>

# btx-pool.com
./nekominer -a btxv4 -o btx-pool.com:3334 -u <ADDRESS>.<WORKER>

# diffpool.xyz
./nekominer -a btxv4 -o btx.diffpool.xyz:3333 -u <ADDRESS>.<WORKER>
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
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a btxv4"
    }
  }]
}
```
</details>

<details>
<summary>BTX btx-pool nekominer</summary>

```json
{
  "name": "BTX btx-pool nekominer",
  "items": [{
    "coin": "BTX",
    "miner": "custom",
    "miner_config": {
      "url": "btx-pool.com:3334",
      "miner": "nekominer-hiveos",
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a btxv4"
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
      "template": "%WAL%.%WORKER_NAME%",
      "install_url": "https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-hiveos-0.18.0.tar.gz",
      "user_config": "-a btxv4"
    }
  }]
}
```
</details>

## Downloads

See [Releases](../../releases).

- **os.dog package:** [`nekominer-osdog-0.18.0.tar.gz`](https://github.com/nr800/nekominer/releases/download/v0.18.0/nekominer-osdog-0.18.0.tar.gz)
