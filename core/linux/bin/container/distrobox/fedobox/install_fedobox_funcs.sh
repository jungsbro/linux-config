#!/bin/bash
set -e

[[ -n "${_INSTALL_FEDOBOX_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_FEDOBOX_FUNCS_LOADED=1

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/container/distrobox/fedobox/install_fedobox_funcs.sh;

# # "fedobox-main"
# local ctr_name="${CTR_NAME}";

# # "docker.io/library/fedora:latest"
# local image="${IMAGE}";

# # true / false
# local vfx_deps="${VFX_DEPS}";

# # "jungs"
# local cur_user="${CUR_USER}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# # container
# local ctr_args=$(get_ctr_args "${ctr_name}" "${image}");
# local pre_init_hooks=$(get_pre_init_hooks "${vfx_deps}" "${cur_user}");
# create_ctr "${ctr_name}" "${image}" "${vfx_deps}" "${cur_user}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# # apps

# install_xcape "${ctr_name}";                      # not used
# install_synapse "${ctr_name}";                    # not used
# install_skippy-xd "${ctr_name}";                  # not used
# install_freefilesync "${ctr_name}" "${cur_user}"; # not used

# install_terminal "${ctr_name}" "${cur_user}";     # not used
# install_autokey "${ctr_name}" "${cur_user}";
# install_redshift "${ctr_name}" "${cur_user}";
# install_gnome-keyring "${ctr_name}";
# install_vscode "${ctr_name}" "${cur_user}";
# install_doublecmd "${ctr_name}";
# install_chromium "${ctr_name}" "${cur_user}";     # not used
# install_google-chrome "${ctr_name}" "${cur_user}";
# install_firefox "${ctr_name}" "${cur_user}";      # not used
# install_remmina "${ctr_name}";
# install_libreoffice "${ctr_name}";                # not used
# install_qpdf "${ctr_name}";
# install_gimp "${ctr_name}" "${cur_user}";         # not used
# install_drawing "${ctr_name}";
# install_vlc "${ctr_name}" "${cur_user}";
# install_kdenlive "${ctr_name}" "${cur_user}";     # not used
# install_shotcut "${ctr_name}" "${cur_user}";      # not used
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function get_core_bin_dir_from_fedobox()
{
    # /core/linux/bin/container/distrobox/fedobox
    local cur_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    local root_dir="${cur_dir}/../../../../../.."

    # core/linux/bin
    local core_bin_dir="${root_dir}/core/linux/bin"

    echo "${core_bin_dir}"
}


function get_ctr_args()
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";

    # "docker.io/library/fedora:latest"
    local image="${2}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # distrobox create --name "fedo-main" --image "docker.io/library/fedora:latest"
    local ctr_args=""

    # container 이름
    # --name "fedobox-main"
    ctr_args+="--name ${ctr_name} "

    # container image주소
    # --image "docker.io/library/fedora:latest"
    ctr_args+="--image ${image} "
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -n $(lspci | grep -E "VGA|3D" | grep -i nvidia) ]]; then
        # nvidia gpu를 사용할때, --nvidia 가 필요하다.
        ctr_args+="--nvidia "

        # puslseAudio 사용을 위해 (pre_init_hooks에서 libpulse0 설치도 필요하다.)
        # --volume "/run/user/1000/pulse:/run/user/1000/pulse"
        ctr_args+="--volume /run/user/${UID}/pulse:/run/user/${UID}/pulse "
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # PipeWire 사용을 위해 (fedora34 이후 / pre_init_hooks에서 libpulse0 설치도 필요하다.)
    # ctr_args+="--volume /run/user/${UID}/pipewire-0:/run/user/${UID}/pipewire-0 "

    # Alsa장치 사용을 위해
    # ctr_args+="--volume /dev/snd:/dev/snd "
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # container에서 호스트의 /opt/ayon 디렉토리를 /opt/ayon으로 마운트한다.
    if [[ -d "/opt/ayon" ]]; then
        ctr_args+="--volume /opt/ayon:/opt/ayon "
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    echo "${ctr_args}";
    # --------------------------------------------------------------------------
}


function get_pre_init_hooks()
{
    # --------------------------------------------------------------------------
    # true / false
    local vfx_deps="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local pre_init_hooks=""

    # update
    pre_init_hooks+="sudo dnf upgrade -y"

    pre_init_hooks+=" && \
        sudo bash ${core_bin_dir}/pkgmgmt/update_repo.sh"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # container에서 사용하는 git wget curl
    pre_init_hooks+=" && \
        sudo dnf install -y git wget curl"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # container에서 사용하는 vim
    pre_init_hooks+=" && \
        sudo dnf install -y vim-X11 xclip xsel"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # container에서 사용하는 fm
    pre_init_hooks+=" && \
        sudo dnf install -y ranger"

    # pre_init_hooks+=" && \
    #     sudo dnf install -y nnn"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다.
    # 방법1)
    pre_init_hooks+=" && \
        sudo dnf install -y fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-autostart"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # gpu-driver (opengl,vulkan,vaapi,opencl)
    pre_init_hooks+=" && \
        sudo bash ${core_bin_dir}/gpu/install_gpu.sh ${cur_user}"

    if [[ "${vfx_deps}" == "true" ]]; then
        # vfx-dcc-dependencies for rocky8 or rocky9
        pre_init_hooks+=" && \
            sudo bash ${core_bin_dir}/gpu/install_vfxdeps.sh"
    fi

    # gpu_top
    pre_init_hooks+=" && \
        sudo bash ${core_bin_dir}/gpu/install_gpu_top.sh"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # puslseAudio 사용을 위해
    pre_init_hooks+=" && \
        sudo dnf install -y pulseaudio-libs"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # bash 사용
    # chsh: your shell is not in /etc/shells, shell change denied: Permission denied
    # sudo를 사용하면 애러가 나지 않는다.
    pre_init_hooks+=" && \
        sudo chsh -s /bin/bash ${cur_user}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    echo "${pre_init_hooks}";
    # --------------------------------------------------------------------------
}

function create_ctr()
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";

    # "docker.io/library/fedora:latest"
    local image="${2}";

    # true / false
    local vfx_deps="${3}";

    # "jungs"
    local cur_user="${4}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local ctr_args=$(get_ctr_args "${ctr_name}" "${image}");

    local pre_init_hooks=$(get_pre_init_hooks "${vfx_deps}" "${cur_user}");
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # checking container
    if [[ "$(distrobox list)" == *"${ctr_name}"* ]]; then
        return 0;
    fi

    # creating container
    # distrobox create "${ctr_args}"; "ERROR: Invalid flag" 가 난다. argument는 띄어쓰기로 구분해하기 때문에
    distrobox create ${ctr_args};

    # pre_init_hooks
    if [[ -n "${pre_init_hooks}" ]]; then
        distrobox enter "${ctr_name}" -- bash -c "${pre_init_hooks}";
    fi
    # --------------------------------------------------------------------------
}


function install_xcape()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # # 존재하지 않는다.
    return 0
    # --------------------------------------------------------------------------
}


function install_synapse()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y synapse

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app synapse
    # --------------------------------------------------------------------------
}


function install_skippy-xd()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # # 존재하지 않는다.
    return 0
    # --------------------------------------------------------------------------
}


function install_freefilesync()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # # 존재하지 않는다.
    return 0

    # installation >> not used
    # https://copr.fedorainfracloud.org/coprs/bgstack15/FreeFileSync/
    # sudo dnf install -y 'dnf-command(copr)'
    # sudo dnf copr enable bgstack15/FreeFileSync
    # --------------------------------------------------------------------------
}


function install_terminal()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # feodra에서 wezterm을 copr로 사용가능하지만 보안상문제로 사용하지 않는다.
    return 0

    # installation
    distrobox enter "${ctr_name}" -- sudo dnf copr enable wezfurlong/wezterm-nightly
    distrobox enter "${ctr_name}" -- sudo dnf install -y wezterm

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app wezterm

    # config (with nvidia)
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${cur_user} ${ctr_name} wezterm"
    # --------------------------------------------------------------------------
}


function install_autokey()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y autokey-gtk

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app autokey-gtk

    # config
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/hotkey/autokey/install_autokey_funcs.sh && \
        config_autokey ${cur_user} && \
        set_autokey_autostart ${cur_user}"
    # --------------------------------------------------------------------------
}

function install_redshift()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y redshift-gtk geoclue2

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app redshift

    # config
    distrobox enter "${ctr_name}" -- bash -c "\
        source ${core_bin_dir}/system/redshift/install_redshift_funcs.sh && \
        config_redshift ${cur_user} && \
        set_redshift_autostart ${cur_user}"
    # --------------------------------------------------------------------------
}


function install_firejail()    # not used
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y firejail
    # --------------------------------------------------------------------------
}


function install_timeshift()    # not used
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # distrobox에서 작동을 안한다.
    return 0

    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y timeshift

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app timeshift
    # --------------------------------------------------------------------------
}


function install_gnome-disk-utility()    # not used
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # distrobox에서 작동을 안한다.
    # 배포판에 이미 설치되어 있다.
    return 0

    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y gnome-disk-utility

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app gnome-disks
    # --------------------------------------------------------------------------
}


function install_gnome-keyring()
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # vscode, remmina에서 사용된다.

    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y gnome-keyring
    # --------------------------------------------------------------------------
}


function install_vscode()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- bash -c "\
        sudo bash ${core_bin_dir}/ide/install_vscode.sh ${cur_user}"

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app code
    # --------------------------------------------------------------------------
}


function install_doublecmd()
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y doublecmd-gtk

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app doublecmd
    # --------------------------------------------------------------------------
}


function install_chromium()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y chromium

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app chromium

    # config (with nvidia)
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${cur_user} ${ctr_name} chromium"
    # --------------------------------------------------------------------------
}


function install_google-chrome()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- bash -c "\
        sudo bash ${core_bin_dir}/internet/install_google-chrome.sh ${cur_user}"

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app google-chrome-stable

    # config (with nvidia)
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${cur_user} ${ctr_name} google-chrome"
    # --------------------------------------------------------------------------
}


function install_firefox()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 배포판에 이미 설치되어 있다.

    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y firefox

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app firefox

    # config (with nvidia)
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${cur_user} ${ctr_name} firefox"
    # --------------------------------------------------------------------------
}


function install_remmina()
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y remmina

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app remmina
    # --------------------------------------------------------------------------
}


function install_libreoffice()
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 배포판에 이미 설치되어 있다.

    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y libreoffice

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app libreoffice
    # --------------------------------------------------------------------------
}


function install_qpdf()
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    # distrobox enter "${ctr_name}" -- sudo dnf install -y qpdfview qpdfview-common qpdfview-qt5 qpdfview-qt6
    distrobox enter "${ctr_name}" -- sudo dnf install -y qpdfview;

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app qpdfview
    # --------------------------------------------------------------------------
}


function install_gimp()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y gimp

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app gimp

    # config : photogimp
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/graphics/gimp/install_gimp_funcs.sh && \
        install_photogimp ${cur_user}"

    # config (with nvidia)
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${cur_user} ${ctr_name} gimp"
    # --------------------------------------------------------------------------
}


function install_drawing()
{
    # --------------------------------------------------------------------------
    # "fedobox-main"
    local ctr_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y drawing

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app drawing
    # --------------------------------------------------------------------------
}


function install_vlc()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y vlc

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app vlc

    # config (with nvidia)
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${cur_user} ${ctr_name} vlc"
    # --------------------------------------------------------------------------
}


function install_kdenlive()     # not used
{
    return 0

    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # error가 난다.
    return 0

    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y kdenlive

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app kdenlive

    # config (with nvidia)
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${cur_user} ${ctr_name} kdenlive"
    # --------------------------------------------------------------------------
}


function install_shotcut()
{
    # --------------------------------------------------------------------------
    # "foeobox-main"
    local ctr_name="${1}";

    # "jungs"
    local cur_user="${2}";

    # core/linux/bin
    local core_bin_dir=$(get_core_bin_dir_from_fedobox);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # installation
    distrobox enter "${ctr_name}" -- sudo dnf install -y shotcut

    # desktop
    distrobox enter "${ctr_name}" -- distrobox-export --app shotcut

    # config (with nvidia)
    distrobox enter "${ctr_name}" -- sudo bash -c "\
        source ${core_bin_dir}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${cur_user} ${ctr_name} shotcut"
    # --------------------------------------------------------------------------
}
# ==============================================================================