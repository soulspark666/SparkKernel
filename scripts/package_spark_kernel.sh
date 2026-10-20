#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# Package the built kernel into a Spark Kernel AnyKernel3 zip.
#
#   ./scripts/package_spark_kernel.sh <kernel-workspace> [output-dir]
#
# The kernel workspace is the checkout of the kernel tree, already built:
#   make O=out ARCH=arm64 LLVM=1 LLVM_IAS=1 ... Image.gz-dtb
#
# The zip layout is plain AnyKernel3: this repository's contents plus the
# built kernel, the built base DTB and a small "spark_version" file that
# the flash script prints.

set -euo pipefail

AKSRC="$(cd "$(dirname "$0")/.." && pwd)"
KERNEL_WS="${1:?usage: package_spark_kernel.sh <kernel-workspace> [output-dir]}"
OUTDIR="${2:-$AKSRC/dist}"
AKDIR="$AKSRC/anykernel"
KERNEL="$KERNEL_WS/out/arch/arm64/boot/Image.gz-dtb"
DTB="$KERNEL_WS/out/arch/arm64/boot/dts/mediatek/mt6893.dtb"

for f in "$AKDIR/anykernel.sh" "$KERNEL" "$DTB"; do
	[ -e "$f" ] || { echo "missing: $f" >&2; exit 1; }
done

GIT_HASH="$(git -C "$KERNEL_WS" rev-parse --short=12 HEAD 2>/dev/null || echo unknown)"
KERNEL_RELEASE="$(cat "$KERNEL_WS/out/include/config/kernel.release" 2>/dev/null || echo unknown)"
BUILD_DATE="$(date -u +%Y%m%d)"
ZIP_NAME="SparkKernel-RMX3031-${BUILD_DATE}-${GIT_HASH}.zip"

mkdir -p "$OUTDIR"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

cp -a "$AKDIR/." "$STAGE/"
cp -f "$KERNEL" "$STAGE/Image.gz-dtb"
cp -f "$DTB" "$STAGE/dtb"

cat > "$STAGE/spark_version" <<EOF
spark_version="${KERNEL_RELEASE}"
spark_git="${GIT_HASH}"
EOF

# Keep the archive reproducible and free of anything but the flash payload.
( cd "$STAGE" && find . -type f -exec touch -t 202401010000.00 {} + )
rm -f "$STAGE/README.md"

( cd "$STAGE" && zip -qr9 "$OUTDIR/$ZIP_NAME" . )

echo "$OUTDIR/$ZIP_NAME"
sha256sum "$OUTDIR/$ZIP_NAME"
