# data_workaround script

To use data_workaround script in your distro, you can add it to your kernel image as a service. This works for me:

### initrd example: init.rc

    on property:dev.bootcomplete=1
        start data_workaround
    
    service data_workaround /system/xbin/busybox sh /sbin/data_workaround
        class late_start
        user root
        group root
        disabled
        oneshot


### Requeriments
You need busybox to run this script properly.
