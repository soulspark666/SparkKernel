### Spark Kernel `4.19.325-SparkKernel-g15788ae3c26a`

Built from `15788ae3c26a` on 2026-10-20.

Device: **realme RMX3031 (Cupida)** / MT6893, kernel 4.19.
Toolchain: LLVM 18.1.3 (clang / lld).

| | |
|---|---|
| Kernel release | `4.19.325-SparkKernel-g15788ae3c26a` |
| Git commit | `15788ae3c26a` |
| Kernel source | `soulspark666/kernel_oplus_mt6893`, branch `port/v2-mt6893` |

---

#### What this kernel is

A custom kernel for the realme RMX3031 (Cupida) built on the MT6893 4.19
tree, with the device's charger stack ported from the OPLUS v1 charger
framework to the OPLUS v2 charger framework. The original vendor boot
chain is kept: the base DTB ships inside the boot image, the stock
`dtbo.img` overlay is untouched, and the kernel is delivered as
`Image.gz-dtb` in a plain AnyKernel3 zip.

#### Highlights

* **Charging works, and the UI says so.** Battery percentage, charging
  current and the status-bar indicator are all live:
  `battery/status` reports `Charging`, `dumpsys battery` reports
  `AC powered: true`, and the lightning bolt shows in the status bar.
* **USB adb works over the cable.** The phone enumerates as a USB device:
  `/sys/class/udc/usb0/state` reaches `configured` at high-speed and
  `adb devices` lists the phone on the USB transport. The UDC also drops
  back to `not attached` when the cable is removed.
* The kernel banner carries no build-host or distribution information —
  just the kernel release and the git hash it was built from.

#### Flash instructions

1. Copy the zip to the device.
2. Boot into TWRP (recovery).
3. `twrp install /sdcard/Download/<zip>` — or from the TWRP GUI:
   *Install* → *Pick zip file*.
4. Reboot to system.

The zip contains `Image.gz-dtb` (the kernel) and `dtb` (the base device
tree). Everything else is the AnyKernel3 flash script and its tools; the
ramdisk in the boot image is left untouched.

#### Notes

* Charging is verified on a 5 V USB charger. The 9 V/12 V VOOC pump path
  is not implemented yet, so fast charging stays at the USB default
  current.
* This is an unofficial build. It is not affiliated with, endorsed by or
  supported by realme, OPPO or OnePlus.

#### Credits

* [AnyKernel3](https://github.com/osm0sis/AnyKernel3) by osm0sis
  (xda-developers) — the flash script this zip is built from.
* The MT6893 kernel tree and the ReSukiSU / KernelSU base.
* Everyone who reported the charging and USB issues this build fixes.
