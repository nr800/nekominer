#!/usr/bin/env python3
"""Build and validate local HiveOS/os.dog release assets; never publish."""
import argparse
import gzip
import hashlib
import io
from pathlib import Path
import re
import shutil
import subprocess
import tarfile

ROOT = Path(__file__).resolve().parents[1]
HIVE = ('h-manifest.conf', 'h-run.sh', 'h-config.sh', 'h-stats.sh')
DOG = ('miner', 'stats', 'utils.sh')


def digest(data, algorithm='sha256'):
    return hashlib.new(algorithm, data).hexdigest()


def archive(path, payload, prefix=''):
    with path.open('wb') as raw, gzip.GzipFile(filename='', mode='wb', fileobj=raw, mtime=0) as gz:
        with tarfile.open(fileobj=gz, mode='w') as tar:
            if prefix:
                entry = tarfile.TarInfo(prefix)
                entry.type = tarfile.DIRTYPE
                entry.mode = 0o755
                tar.addfile(entry)
            for name, data in payload.items():
                entry = tarfile.TarInfo(prefix + name)
                entry.size = len(data)
                entry.mode = 0o644 if name in ('h-manifest.conf', 'files.md5') else 0o755
                tar.addfile(entry, io.BytesIO(data))
    # Validate exact names, contents, types, and permissions without extraction.
    with tarfile.open(path) as tar:
        expected = {prefix + name for name in payload}
        if prefix:
            expected.add(prefix.rstrip('/'))
        assert set(tar.getnames()) == expected, 'Unexpected archive layout'
        for name, data in payload.items():
            entry = tar.getmember(prefix + name)
            assert entry.isfile() and not entry.issym() and not entry.islnk()
            assert tar.extractfile(entry).read() == data
            assert entry.mode == (0o644 if name in ('h-manifest.conf', 'files.md5') else 0o755)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('version', help='Release version without v prefix')
    parser.add_argument('--binary', type=Path, default=ROOT / 'nekominer')
    parser.add_argument('--output', type=Path, default=ROOT / 'dist')
    args = parser.parse_args()
    if not re.fullmatch(r'\d+\.\d+\.\d+', args.version):
        parser.error('Expected version X.Y.Z')
    binary = args.binary.read_bytes()
    if binary[:6] != b'\x7fELF\x02\x01' or binary[18:20] != b'\x3e\x00':
        parser.error('Expected an ELF64 little-endian x86-64 binary')
    hive = {'nekominer': binary, **{name: (ROOT / 'hiveos' / name).read_bytes() for name in HIVE}}
    dog = {'nekominer': binary, **{name: (ROOT / 'osdog' / name).read_bytes() for name in DOG}}
    for source in [*(ROOT / 'hiveos' / n for n in HIVE if n.endswith('.sh')), *(ROOT / 'osdog' / n for n in DOG)]:
        subprocess.run(['bash', '-n', str(source)], check=True)
    dog['files.md5'] = ''.join(digest(data, 'md5') + '  ' + name + '\n' for name, data in dog.items()).encode()
    args.output.mkdir(parents=True, exist_ok=True)
    assets = [args.output / f'nekominer-hiveos-{args.version}.tar.gz', args.output / f'nekominer-osdog-{args.version}.tar.gz']
    archive(assets[0], hive, 'nekominer-hiveos/')
    archive(assets[1], dog)
    # Include the standalone binary alongside the integration packages.
    standalone = args.output / f'nekominer-{args.version}'
    shutil.copyfile(args.binary, standalone)
    standalone.chmod(0o755)
    assets.append(standalone)
    sums = args.output / f'SHA256SUMS-{args.version}'
    sums.write_text(''.join(digest(path.read_bytes()) + '  ' + path.name + '\n' for path in assets))
    print(sums.read_text(), end='')
    print('Archive layouts, payloads, permissions and Bash syntax verified.')
    print('Binary version and GPU execution require a system with NVIDIA libraries.')


if __name__ == '__main__':
    main()
