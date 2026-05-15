distrobox create --name rkl9box --image "docker.io/library/rockylinux:9.3" --nvidia --init --additional-packages systemd;


$ ls -l /lib64/libcuda.so*
ls -l /lib64/libnvcuvid.so*


# ==============================================================================
container안에서
lrwxrwxrwx. 1 root   root         19 Feb 11 10:33 /lib64/libcuda.so -> /lib64/libcuda.so.1
-rwxr-xr-x. 1 nobody nobody 96276264 Dec 31 09:37 /lib64/libcuda.so.1
-rwxr-xr-x. 1 nobody nobody 96276264 Dec 31 09:37 /lib64/libcuda.so.580.105.08
lrwxrwxrwx. 1 root   root         22 Feb 11 10:33 /lib64/libnvcuvid.so -> /lib64/libnvcuvid.so.1
-rwxr-xr-x. 1 nobody nobody 20749880 Dec 31 09:37 /lib64/libnvcuvid.so.1
-rwxr-xr-x. 1 nobody nobody 20749880 Dec 31 09:37 /lib64/libnvcuvid.so.580.105.08

host에서
$ maya
/usr/autodesk/maya2025/bin/maya.bin: error while loading shared libraries: libOpenGL.so.0: cannot open shared object file: No such file or directory
여전히 애러가 난다.
# ==============================================================================



# ==============================================================================
# container안에서
$ sudo dnf install mesa-libGL mesa-libGLU mesa-libEGL

Last metadata expiration check: 1:52:02 ago on Wed 11 Feb 2026 08:47:07 AM UTC.
Package mesa-libGL-25.0.7-3.el9_7.x86_64 is already installed.
Package mesa-libGLU-9.0.1-6.el9.x86_64 is already installed.
Package mesa-libEGL-25.0.7-3.el9_7.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!


$ ldconfig -p | grep libOpenGL

# ==============================================================================


# container 안에서
dnf list --installed | grep -i mesa
mesa-dri-drivers.x86_64               25.0.7-3.el9_7               @appstream
mesa-filesystem.x86_64                25.0.7-3.el9_7               @appstream
mesa-libEGL.x86_64                    25.0.7-3.el9_7               @appstream
mesa-libGL.x86_64                     25.0.7-3.el9_7               @appstream
mesa-libGLU.x86_64                    9.0.1-6.el9                  @appstream
mesa-libgbm.x86_64                    25.0.7-3.el9_7               @appstream
mesa-vulkan-drivers.x86_64            25.0.7-3.el9_7               @appstream

 11:01:23  jungs@h510mh2-rocky9x  ~/my_scripts/mount 
$ ldconfig -p | grep libOpenGL
아무것도 없음
 11:01:55  ✘  jungs@h510mh2