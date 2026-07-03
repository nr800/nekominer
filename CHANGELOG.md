# Changelog

## [0.11.29] — 2026-07-03

- **Hashrate improvements.**


## [0.11.28] — 2026-06-30

- **BTX hashrate further improved.**

## [0.11.27] — 2026-06-30

- **BTX dev fee reduced from 10% to 1%.**
- **BTX hashrate significantly improved.**

## [0.11.25] — 2026-06-18

- Added **Bitweb (BTE)** algorithm — Argon2id (m=1 MiB, t=3, p=1) memory-hard PoW; 1% dev fee. ~55 kH/s per RTX 3070 with memory OC (memory-bandwidth-bound — mem clock is the lever, core barely matters).

## [0.11.23] — 2026-06-17

- Added **BTX** algorithm — MatMul PoW with multi-pool support: ninjaraider.com (`--pool-proto ninja`, default), minebtx.com and bitminerpool.xyz (`--pool-proto minebtx`), AriaBrain at `stratum.ariabrain.com` (`--pool-proto aria`).
- Added **Equihash (192,7)** algorithm — Ycash (YEC), Zcash-style PoW.
- VecnoHash: minor hashrate improvements.
- Exfer: minor hashrate improvement.
- **CPU load eliminated** — all algorithms now use blocking GPU sync (near-zero CPU usage / load average, frees host cores).

## [0.9.23] — 2026-05-09

- Added Tesla P100 (sm_60) GPU support.
- Fixed exfer OOM crash on multi-GPU rigs.

## [0.9.19] — 2026-05-03

- Exfer hashrate boost (~814 H/s on RTX 3070 Ti Laptop).
- Fixed out-of-memory on multi-GPU rigs.

## [0.9.15] — 2026-05-02

- Added **luckypool.io** compatibility for Exfer algorithm (auto-detects pool protocol).
- Keryx (KHeavyHash) algorithm support.

## [0.9.13] — 2026-04-25

- Fixed high CPU load average on multi-GPU rigs (now correctly sleeps while waiting for GPU on all devices, not just the first).

## [0.9.12] — 2026-04-25

- Added **Exfer** algorithm — Argon2id memory-hard PoW (~580 H/s on RTX 3070 Ti Laptop).

## [0.7.x] — 2026-03-27 → 2026-04-03

- Autotune progress logs and 15-second tuning window.
- Various performance and stability improvements.

## [0.6.0] — 2026-03-26

- Added **VecnoHash** algorithm (Vecno blockchain).

## [0.5.x] — 2026-03-25

- DUTAHash performance improvements (~38 KH/s on RTX 3070).

## [0.4.x] — 2026-03-23

- SSL/TLS support and dev fee.
- DUTAHash algorithm.
- HiveOS/os.dog packaging.

## [0.3.x] — 2026-03-19

- BLAKE3 performance: 1.9 → 3.6 GH/s on RTX 3070.

## [0.2.x] — 2026-03-19

- Multi-GPU support, colored output, stats table.

## [0.1.0] — 2026-03-19

- Initial release: BLAKE3 (Qado) CUDA GPU miner.
