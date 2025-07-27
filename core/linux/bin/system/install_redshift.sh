#!/bin/bash

# redshift =====================================================================
# bash /core/linux/bin/system/install_redshift.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function autostart_redshift()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------
    
    # --------------------------------------------------------------------------
    local START_DIR='${HOME}/.config/autostart'
    local START_PATH="${START_DIR}/redshift-gtk.desktop"
    
    local START_CMD="[Desktop Entry]
Version=1.0
Name=Redshift
Name[be]=Redshift
Name[ca]=Redshift
Name[cs]=Redshift
Name[da]=Redshift
Name[de]=Redshift
Name[en_GB]=Redshift
Name[es]=Redshift
Name[fr]=Redshift
Name[he]=Redshift
Name[hu]=Redshift
Name[it]=Redshift
Name[ja]=Redshift
Name[lt]=Redshift
Name[nb]=Rødskift
Name[pl]=Redshift
Name[pt]=Redshift
Name[pt_BR]=Redshift
Name[ro]=Redshift
Name[ru]=Redshift
Name[sr]=Редшифт
Name[sv]=Redshift
Name[tr]=Redshift
Name[uk]=Redshift
Name[zh_CN]=红移
Name[zh_TW]=Redshift
GenericName=Color temperature adjustment
GenericName[be]=Рэгуляванне каляровай тэмпературы
GenericName[ca]=Ajust de la temperatura de color
GenericName[cs]=Nastavení teploty barev
GenericName[da]=Justering af farvetemperatur
GenericName[de]=Farbtemperaturanpassung
GenericName[en_GB]=Colour temperature adjustment
GenericName[es]=Ajuste de la temperatura de color
GenericName[fr]=Réglage de la température de couleur
GenericName[he]=התאמת טמפרטורת צבע
GenericName[hu]=Színhőmérséklet beállítása
GenericName[it]=Regolazione della temperatura del colore
GenericName[ja]=色温度の調整
GenericName[lt]=Spalvos temperatūros reguliavimas
GenericName[nb]=Justering av fargetemperatur
GenericName[nl]=Bijstelling van kleurtemperatuur
GenericName[pl]=Dostosowanie temperatury barwowej
GenericName[pt_BR]=Ajuste de temperatura de cor
GenericName[ru]=Настройка цветовой температуры
GenericName[sr]=Прилагођавање температуре боје
GenericName[sv]=Färgtemperaturjustering
GenericName[tr]=Renk sıcaklığı ayarı
GenericName[uk]=Налаштування колірної температури
GenericName[zh_CN]=色温调节
GenericName[zh_TW]=色溫調整
Comment=Color temperature adjustment tool
Comment[be]=Інструмент рэгулявання каляровай тэмпературы
Comment[ca]=Eina per a l'ajust de la temperatura de color
Comment[cs]=Nástroj pro přizpůsobení barevné teploty
Comment[da]=Justeringsværktøj for farvetemperatur
Comment[de]=Farbtemperaturanpassungswerkzeug
Comment[en_GB]=Colour temperature adjustment tool
Comment[es]=Herramienta para el ajuste de la temperatura de color
Comment[fr]=Outil de réglage de la température de couleur
Comment[he]=כלי להתאמת טמפרטורת צבע
Comment[hu]=Színhőmérséklet beállító eszköz
Comment[it]=Strumento per la regolazione della temperatura del colore
Comment[ja]=色温度の調整ツール
Comment[lt]=Spalvos temperatūros reguliavimo įrankis
Comment[nb]=Justeringsverktøy for fargetemperatur
Comment[nl]=Hulpmiddel voor het bijstellen van de kleurtemperatuur
Comment[pl]=Narzędzie do dostosowywania temperatury barwowej
Comment[pt_BR]=Ferramenta de ajuste de temperatura de cor
Comment[ru]=Инструмент регулирования цветовой температуры
Comment[sr]=Алатка за прилагођавање температуре боје
Comment[sv]=Justeringsverktyg för färgtemperaturer
Comment[tr]=Renk sıcaklığı ayarlama aracı
Comment[uk]=Знаряддя налаштувань колірної температури
Comment[zh_CN]=色温调节工具
Comment[zh_TW]=色溫調整工具
Exec=redshift-gtk
Icon=redshift
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=true
Hidden=false
X-GNOME-Autostart-enabled=true"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -d ${START_DIR} ]] || mkdir -p ${START_DIR}";
    su - ${CUR_USER} -c "[[ -f ${START_PATH} ]] || echo '${START_CMD}' > ${START_PATH}";
    # --------------------------------------------------------------------------
}

function config_redshift()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------
    
    # --------------------------------------------------------------------------
    local CONF_CMD="[redshift]
temp-day=5500
temp-night=3800

location-provider=manual
adjustment-method=randr

[manual]
lat=37.6
lon=127.0"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/redshift.conf
    su - ${CUR_USER} -c "[[ -f ~/.config/redshift.conf ]] || echo '${CONF_CMD}' > ~/.config/redshift.conf";
    # --------------------------------------------------------------------------
    
    # --------------------------------------------------------------------------
    autostart_redshift;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^redshift) ]] || apt install -y redshift-gtk;
    [[ -n $(apt list --installed | grep -i ^geoclue) ]] || apt install -y geoclue-2.0;
    # --------------------------------------------------------------------------
    config_redshift;

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^redshift) ]] || yum install -y redshift-gtk;
    [[ -n $(yum list installed | grep -i ^geoclue) ]] || yum install -y geoclue2;
    # --------------------------------------------------------------------------
    config_redshift;

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^redshift) ]] || dnf install -y redshift-gtk;
    [[ -n $(dnf list installed | grep -i ^geoclue) ]] || dnf install -y geoclue2;
    # --------------------------------------------------------------------------
    config_redshift;
fi
# ==============================================================================

exit 0