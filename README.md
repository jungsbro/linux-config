# **Linux-Config**

<br><br>

# **FolderTree**

```bash
# ==============================================================================
.config/                # app-config dir
    autostart/
    geany/
    mc/
    midori/
    openbox/
    xed/
    user-dirs.dirs      # for userDirs(English)
    user-dirs.locale    # for locale(English)
# ------------------------------------------------------------------------------
.gimp-2.8/
# ------------------------------------------------------------------------------
.git/
# ------------------------------------------------------------------------------
.icons/                 # Papirus icons이 들어가 있다.(용량은 85mb)
# ------------------------------------------------------------------------------
.moc/                   # moc-config (console music player)
# ------------------------------------------------------------------------------
.themes/                # Adwaita-dark (adwaita-dark theme)
# ------------------------------------------------------------------------------
myScpripts/             # favorite shellscripts
# ==============================================================================
.bash_profile           # bash
.bashrc
# ------------------------------------------------------------------------------
.selected_editor        # settings default editor(vim)
# ------------------------------------------------------------------------------
auto.master             # autofs
auto.smb.shares
# ------------------------------------------------------------------------------
basicDir.sh             # shellscript for userDirs(English)
# ------------------------------------------------------------------------------
fstab                   # /etc/fstab
# ------------------------------------------------------------------------------
mount.sh                # shellscript for mount
# ------------------------------------------------------------------------------
README.md               #
# ==============================================================================
```

---

<br><br>

# **Installation**

> Update repository-list

```bash
sudo apt update;
```

<br>

> Development

```bash
sudo apt install -y git build-essential python3-pip python3-dev python3-setuptools;
```

<br>

> Maintenance

```bash
# ==============================================================================
unattended-upgrades     # Auto update
autofs                  # Auto filesystem (auto mount)
neofetch                # Impormation for OS
net-tools               # NETwork-TOOLs (ifconfig, route, ...)
hdparm                  # checking disk-reading
htop                    # Process Monitoring
glances                 # monitoring tools
ncdu                    # NCurses Disk Usage
nmon                    # Niegel performance MONitor
# ==============================================================================
```

```bash
sudo apt install -y unattended-upgrades autofs neofetch net-tools htop hdparm ncdu nmon mc bpytop whois cifs-utils rsync rclone;
```

<br>

> Screen-saver

```bash
# ==============================================================================
nyancat                 # nyancat screen-saver
cmatrix                 # matrix screen-saver
tty-clock               # cloock screen-saver
# ==============================================================================
```

```bash
sudo apt install -y nyancat cmatrix tty-clock;
```

<br>

> Filesystem

```bash
# ==============================================================================
ntfs-3g                 # ntfs for linux
exfat-utils             # exfat for linux ( exfat-utils, exfat-fuse )
exfat-fuse              # exfat for linux ( exfat-utils, exfat-fuse )
# ==============================================================================
```

```bash
sudo apt install -y ntfs-3g exfat-utils exfat-fuse;
```

<br>

> ETC

```bash
# ==============================================================================
mc                      # midnight commander
fonts-noto-cjk          # fonts
fonts-roboto            # fonts
# ==============================================================================
```

```bash
sudo apt install -y mc fonts-noto-cjk fonts-roboto;
```

[vim-config](https://github.com/jungsbro/vim-config)

[tmux-config](https://github.com/jungsbro/tmux-config)

[zsh-config](https://github.com/jungsbro/zsh-config)

[ranger-config](https://github.com/jungsbro/ranger-config)
<br><br>

> UI

```bash
# ==============================================================================
chromium                # chromium browser
geany                   # ide
geany-plugins           # ide plugin
filezilla               # ftp client
papirus-icon-theme      # desktop icon themes
redshift-gtk            # bluelight
timeshift               # os snapshot
# ==============================================================================
```

```bash
sudo apt install -y chromium;
```

```bash
sudo apt install -y geany geany-plugins filezilla;
```

```bash
sudo apt install -y papirus-icon-theme;
```

```bash
sudo apt install -y redshift-gtk timeshfit;
```

[doublecmd-config](https://github.com/jungsbro/doublecmd-config)

[conky-config](https://github.com/jungsbro/conky-config)
<br><br>

> Clone linux-config

```bash
git clone https://github.com/jungsbro/linux-config.git ~/github/linux-config
```

```bash
cp -f ~/github/linux-config/.config/redshift.conf ~/.config/redshift.conf;
cp -f ~/github/linux-config/.selected_editor ~/.selected_editor;
cp -f ~/github/linux-config/mount.sh ~/mount.sh;
```

<br>

---

<br><br>

# **Settings**

> Panel : date, time 설정

`22-08-07 (Sun)  AM 01:24`

```bash
%y-%m-%d (%a)  %p %I:%M
```

<br>

`AM 01:25<br>`
`22-08-07 (Sun)`

```bash
%p %I:%M%n%y-%m-%d (%a)
```

<br><br>

> TimeZone 설정

`Asia/Seoul`

```bash
sudo dpkg-reconfigure tzdata
```

<br><br>

> locale 설정

`en_US.UTF-8`
`ko_KR.UTF-8`

```bash
locale

sudo dpkg-reconfigure locales
```

<br><br>

> BlueLight 설정

```bash
sudo apt install redshift
```

```bash
vi ~/.confing/redshift.conf
```

```bash
[redshift]
temp-day=5500
temp-night=3800

location-provider=manual
adjustment-method=randr

[manual]
lat=37.6
lon=127.0
```

<br><br>

> Linux / Windows 듀얼부팅시 메인모드시간 설정

```bash
timedatectl set-local-rtc 1 --adjust-system-clock
```

```bash
timedatectl
```

<br><br>

> 한글 설정

1. 한글폰트 설치

`# 나눔폰트`

```bash
sudo apt install -y fonts-nanum fonts-nanum-coding fonts-nanum-extra;
```

`# 은폰트`

```bash
sudo apt install -y fonts-unfonts-core fonts-unfonts-extra;
```

<br>

2. nabi 한글입력기

`2-1. nabi 설치`

```bash
apt install -y nabi im-switch;
```

`2-2. nabi 설정`

```
im-config -s nabi;
im-config -c;
```

`2-3. 기본 입력기 설정`

```bash
sudo vi /etc/default/im-config
```

```bash
IM_CONFIG_DEFAULT_MODE=ibus
```

```bash
reboot
```

<br>

2. ibus 한글입력기

`2-1. ibus 설치`

```bash
sudo apt install ibus ibus-hangul
```

`2-2. Preference → IBus Preference`

```bash
# ==============================================================================
Input Method : Korean - Hangul
# ==============================================================================
```

`2-3. 기본 입력기 설정`

```bash
sudo vi /etc/default/im-config
```

```bash
IM_CONFIG_DEFAULT_MODE=ibus
```

```bash
reboot
```

<br>

2. fcitx 한글입력기

`2-1. fcitx 설치`

```bash
sudo apt install fcitx fcitx-hangul fcitx-frontend-* fcitx-config-gtk fcitx-ui-classic fcitx-tools
```

`2-2. 기본 입력기 설정1 (Preference → 기본 입력기)`

```bash
auto    activate IM with fcitx
```

`2-3. 기본 입력기 설정2`

```bash
sudo vi /etc/default/im-config
```

```bash
IM_CONFIG_DEFAULT_MODE=fcitx
```

```bash
reboot
```

`2-4. Preference → Fcitx Configure`

```bash
# ==============================================================================
Input Method    Keyboard -Korean -Korean(101/104 key compatible) # for English
                Hangul                                           # for Korean
# ==============================================================================
Global Config   Trigger Input Method : Shift+Space / Hangul
# ==============================================================================
```

<br>

2. uim(벼루) 한글입력기

`2-1. uim 설치`

```bash
sudo apt install uim uim-byeoru
```

`2-2. Preference → Input Method (파란색 아이콘)`

```bash
# ==============================================================================
Global settings         Specify default IM      : on
                        Default input method    : Byeru
# ==============================================================================
Toolbar                 Display behvior
                        Display                 : Never
# ==============================================================================
Byeoru                  Properties
                        ESC turns off Hangul mode (for vi users)    : on
# ==============================================================================
Byeoru key binding 1    [Byeoru] on     : "<Shift>space", hangul
                        [Byeoru] off    : "<Shift>space", hangul
# ==============================================================================
```

`2-3. 기본 입력기 설정 (Preference → Input Method(흰색키보드))`

```bash
sudo vi /etc/default/im-config
```

```bash
IM_CONFIG_DEFAULT_MODE=uim
```

```bash
reboot
```

<br><br>

> 한글 유저디렉토리 영문으로 변환

`# 방법1`

```bash
export LANG=C;
xdg-user-dirs-gtk-update;
```

`# 방법2`

```bash
cd ~;
mkdir Desktop Downloads Templates Public Documents Music Pictures Videos;
vi ~/.config/user-dirs.dirs;
```

```bash
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"
```

```
reboot
```

<br><br>

> user가 설정한 내용 root 사용

```bash
sudo rm -Rf /root/.config;
sudo cp -Rf ~/.config /root/.config;

sudo rm -Rf /root/.vim;
sudo cp -Rf ~/.vim /root/.vim;

sudo cp -f ~/.vimrc /root/.vimrc;

sudo cp -f ~/.selected_editor /root/.selected_editor;
```

<br><br>

> fstab 설정

```bash
sudo blkid;

sudo mkdir -p /mnt/{a3004ns,jessie,j4105}/_share;

sudo vi /etc/fstab;
```

```bash
# samba
//192.168.0.0/hdd1  /mnt/a3004ns    cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0
# //192.168.0.0/_share  /mnt/jessie/_share   cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0
# //192.168.0.0/_share  /mnt/j4105/_share   cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0

# nfs
# 192.168.0.0:/volume1/docker_data  /mnt/jessie/_private/docker_data nfs defaults    0   0
# 192.168.0.0:/export/docker_data   /mnt/j4105/_private/docker_data nfs defaults    0   0

# storage
# UUID=a1111111-1111-1111-1111-111111111111   /volume1    ext4    defaults,noatime,nofail 0   0
# UUID=b1111111-1111-1111-1111-111111111111   /volume2    ext4    defaults,noatime,nofail 0   0
```

<br><br>

> samba 설치

```bash
sudo apt install samba samba-common cifs-utils
```

`# pi(user) 생성`

```bash
sudo useradd -m -g pi pi
sudo passwd pi
```

`# samba에서 사용할 passwd 설정`

```bash
sudo smbpasswd -a pi
```

`# samba user확인`

```bash
sudo pdbedit -L -v
```

`# samba 설정`

```bash
sudo vi /etc/samba/smb.conf
```

```bash
#======================= Global Settings =======================
[global]
#### For symbolic link access ####
   follow symlinks = yes
   wide links = yes
   unix extensions = no

####### Authentication #######
# window10 : error 86
    ntlm auth = true

#======================= Share Definitions =======================
[pi]
    comment = pi HOME
    path = /home/pi
    public = no
    writable = yes
    browseable = yes
    valid users = pi

[common]
    comment = common HOME
    path = /home/common
    public = yes
    writable = yes
    directory mode = 0775
    create mode = 0775
    force group = product
    valid users = pi pi2 pi3
```

```bash
sudo systemctl restart smbd;
sudo systemctl enable smbd;
sudo systemctl status smbd;
sudo smbstatus
```

```bash
sudo ufw allow 139/tcp;
sudo ufw allow 445/tcp;
sudo ufw status;
```

<br><br>

> nfs (server) 설치

```bash
sudo apt update
sudo apt install nfs-common nfs-kernel-server rpcbind
```

`# 공유폴더 생성`

```bash
sudo mkdir -p /volume1/docker_data
sudo chmod 707 /volume1/docker_data
```

`# 공유폴더/허가 호스트(192.168.0.*)/폴더권한 설정`

```bash
sudo vi /etc/exports
```

```bash
/volume1/docker_data 192.168.0.*(rw,sync)
```

`# nfs 재시작`

```bash
sudo systemctl restart nfs-server
sudo systemctl enable nfs-server
```

`# nfs 공유정보 확인`

```bash
sudo exportfs -v
```

<br>

> nfs (client) 설치

```bash
sudo apt update
sudo apt install nfs-common
```

`# nfs server(192.168.0.100) 정보 출력(-e:exports)`

```bash
sudo showmount -e 192.168.0.100
```

`# 방법1) mount`

```bash
mkdir /mnt/jessie/docker_data
sudo mount -t nfs 192.168.0.100:/volume1/docker_data /mnt/jessie/docker_data
cd /mnt/jessie/docker_data
ls -al
```

`# 방법2) fstab`

```bash
sudo vi /etc/fstab
```

```bash
192.168.0.100:/volume1/docker_data  /mnt/jessie/_private/docker_data nfs defaults    0   0
192.168.0.200:/export/docker_data   /mnt/j4105/_private/docker_data nfs defaults    0   0

```

<br><br>

> fail2ban 설치

```bash
sudo apt install fail2ban
```

`# fail2ban 설정`

```bash
# ==============================================================================
/etc/fail2ban/action.d      # filter를 통한 추려진 결과에 추가적인 action
# ------------------------------------------------------------------------------
/etc/fail2ban/filter.d      # logpath에서 filter를 통해 문제가 되는 ip를 추려내게 된다.
# ------------------------------------------------------------------------------
/etc/fail2ban/jail.d
/etc/fail2ban/jail.conf
/etc/fail2ban/jail.local    # 각각의 filter별로 설정( 참고 logpath를 설정 )
# ==============================================================================
```

`# vi /etc/fail2ban/jail.local`

```bash
[DEFAULT]
ignoreip = 127.0.0.1/8 192.168.0.0/24
bantime = -1 # 10m 1h(3600), -1
findtime = 24h
maxretry = 5
banaction = iptables-multiport


[sshd]
enabled = true
port = ssh,2222
logpath = %(sshd_log)s
Backend = %(sshd_backend)s
```

`# fail2ban 재시작`

```bash
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban
```

`# fail2ban sshd 상태 확인`

```bash
fail2ban-client status sshd
```

`# unban ip`

```bash
fail2ban-client unbanip 222.222.222.222

fail2ban-client unban --all
```

<br><br>

> openSSH 설치

```bash
sudo apt install -y openssh-server
```

```bash
sudo systemctl restart ssh;
sudo systemctl enable ssh;
sudo systemctl status ssh;
```

```bash
sudo ufw allow 22/tcp;
sudo ufw status;
```

<br><br>

> ssh 포트(22 → 2222) 변경

```bash
sudo vi /etc/ssh/sshd_config
```

```bash
Port 2222
```

`# sshd 재시작`

```bash
sudo systemctl restart sshd
```

`# ssh(192.168.0.100) 접속`

```bash
ssh -p 2222 user@192.168.0.100
```

<br><br>

> client에서 ssh보안키를 생성후, 서버(192.168.0.100)에 등록

1. client에서 ssh 보안키 생성

```bash
ssh-keygen -t rsa;
```

2. 서버(192.168.0.100) authorized_keys에 id_rsa.pub을 등록

`# scp ~/.ssh/id_rsa.pub test@192.168.0.100:~/.ssh/authorized_keys`

```bash
ssh-copy-id test@192.168.0.100
```

<br><br>

> 원격접속(xrdp)

1. xrdp 설치

```bash
sudo apt install xserver-xorg-core xrdp xserver-xorg-input-all -y
```

```bash
sudo vi /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
```

```bash
[Allow Colord all Users]
Identity=unix-user:*

Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile

ResultAny=no

ResultInactive=no

ResultActive=yes
```

3. xrdp 재시작

```bash
sudo systemctl restart xrdp;

sudo ufw allow 3389/tcp;
sudo ufw status;

sudo reboot;
# cinnamon, mate, xfce4는 여기까지하면 정상 작동한다.
```

4. xrdp 원격 접속시 검정화면만 뜰경우 (빈 화면만 뜰 경우)

`# 방법1 `

- 다른 ID를 생성한다. ( sudo adduser user1 )
- 자동로그인 비활성화
- 기존에 설치된 vnc를 지운다. ( sudo apt autoremove --purge realvnc-vnc-server )

`# 방법2. (unset 부분 추가)`

```bash
sudo vi /etc/xrdp/startwm.sh
```

```bash
if test -r /etc/profile; then
        . /etc/profile
fi

unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR

test -x /etc/X11/Xsession && exec /etc/X11/Xsession
exec /bin/sh /etc/X11/Xsession
```

`xrdp 재시작`

```bash
source ~/.profile;
sudo systemctl resrat xrdp;
# lxde는 여기까지하면 정상 작동한다.
```

<br><br>

> zRAM

1. xrdp 설치

```bash
git clone https://github.com/foundObjects/zram-swap

cd zram-swap

sudo ./install.sh
```

2. 확인

```bash
sudo cat /proc/swaps
```

---

<br><br>
