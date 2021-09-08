# AFL++ CoreSight mode

Binary-only fuzzing using ARM64 CoreSight.

## Getting started

### Build coresight-trace

```bash
./build_coresight_trace_support.sh
```

### Build glibc

```bash
patch -p1 < patches/0001-Add-AFL-forkserver.patch
```

```bash
mkdir -p glibc/build
cd glibc/build
../configure --prefix=$PREFIX
make
make install DESTDIR=$DESTDIR
```

### Build patchelf

```bash
cd patchelf
./bootstrap.sh
./configure
make
make check
```

### Patch COTS binary

```bash
patchelf --set-interpreter $DESTDIR/lib/ld-linux-aarch64.so.1 \
  --set-rpath $DESTDIR/lib \
  --output $BIN-patched \
  $BIN
```

### Run afl-fuzz

```bash
sudo afl-fuzz -P -i input -o output -- $BIN-patched @@
```
