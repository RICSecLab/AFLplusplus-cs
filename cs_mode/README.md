# AFL++ CoreSight mode

CoreSight mode enables binary-only fuzzing on ARM64 Linux using CoreSight.

NOTE: CoreSight mode is in the early development stage. Not applicable for production use.

## Getting started

Please read the [RICSec/coresight-trace README](https://github.com/RICSecLab/coresight-trace/blob/master/README.md) and check the prerequisites before getting started.

CoreSight mode supports the AFL fork server mode to reduce fork system call overhead. To support it for binary-only fuzzing, it needs to modify the target ELF binary to re-link to the patched glibc. We employ this design from [PTrix](https://github.com/junxzm1990/afl-pt).

Check out all the git submodules in the `cs_mode` directory:

```bash
git submodule update --init --recursive
```

### Build coresight-trace

There are some notes on building coresight-trace. Refer to the [README](https://github.com/RICSecLab/coresight-trace/blob/master/README.md) for the details. Run the helper shell script.

```bash
./build_coresight_trace_support.sh
```

Make sure `cs-proxy` is placed in the AFL++ root directory as `afl-cs-proxy`.

### Build patchelf

Build ELF patch utility patchelf.

```bash
cd patchelf
./bootstrap.sh
./configure
make
make check
```

### Build glibc

Apply the patch, and install the glibc.

```bash
patch -p1 < patches/0001-Add-AFL-forkserver.patch
mkdir -p glibc/build
cd glibc/build
../configure --prefix=$PREFIX
make
make install DESTDIR=$DESTDIR
```

### Patch COTS binary

Patch the target ELF binary to link to the patched glibc.

```bash
patchelf --set-interpreter $DESTDIR/lib/ld-linux-aarch64.so.1 \
  --set-rpath $DESTDIR/lib \
  --output $BIN-patched \
  $BIN
```

### Run afl-fuzz

Run customized AFL++ with `-P` option to use CoreSight mode.

```bash
sudo afl-fuzz -P -i input -o output -- $BIN-patched @@
```

## Environment Variables

There are AFL++ CoreSight mode-specific environment variables for run-time configuration.

* `AFL_CS_CUSTOM_BIN` overrides the proxy application path. `afl-cs-proxy` will be used if not defined.

* `AFLCS_COV` specifies coverage type on CoreSight trace decoding. `edge` and `path` is supported. The default value is `edge`.
* `AFLCS_UDMABUF` is the u-dma-buf device number used to store trace data in the DMA region. The default value is `0`.
