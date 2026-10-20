### AnyKernel3 Ramdisk Mod Script
## Spark Kernel -- built by soulspark
## AnyKernel3 base: osm0sis @ xda-developers
## Device: realme RMX3031 (Cupida) / MT6893

### AnyKernel setup
# global properties
properties() { '
kernel.string=SparkKernel by soulspark
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=RMX3031
device.name2=CUPIDA
device.name3=cupida
device.name4=denniz
device.name5=MT6893
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=/dev/block/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

### Spark Kernel banner
spark_banner() {
ui_print "  ____  _   _ ____  _    _  ____  ";
ui_print " / ___|| | | |  _ \\| |  | |/ ___| ";
ui_print " \\___ \\| |_| | |_) | |__| | |     ";
ui_print "  ___) |  _  |  _ <|  __  | |___  ";
ui_print " |____/ |_| |_|_| \\_\\_| |_|\\____| ";
ui_print " ";
ui_print "  K e r n e l   f o r   R M X 3 0 3 1";
ui_print " ";
ui_print "  built by soulspark";
ui_print "  version: $spark_version";
ui_print "  git:     $spark_git";
ui_print " ";
} # end banner

# spark_version / spark_git are written by the packaging step
if [ -f "$AKHOME/spark_version" ]; then
	. "$AKHOME/spark_version";
fi;

spark_banner;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install
