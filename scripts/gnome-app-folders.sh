#!/usr/bin/env bash
#
# Declarative GNOME app-grid folder layout.
#
# Apps listed here that aren't installed are silently ignored by GNOME,
# and show up in their folder automatically once installed — so this is
# a superset layout that's safe to apply on any machine.
# Apps not listed anywhere stay at the top level of the grid.

set -euo pipefail

if ! command -v gsettings >/dev/null 2>&1 \
  || ! gsettings get org.gnome.desktop.app-folders folder-children >/dev/null 2>&1; then
  echo "GNOME not detected; skipping app-folder setup."
  exit 0
fi

FOLDER_SCHEMA="org.gnome.desktop.app-folders.folder"
FOLDER_BASE="/org/gnome/desktop/app-folders/folders"

# folder <id> <display-name> <app.desktop>...
folder() {
  local id="$1" name="$2"
  shift 2
  local apps=""
  local app
  for app in "$@"; do
    apps+="'${app}', "
  done
  gsettings set "${FOLDER_SCHEMA}:${FOLDER_BASE}/${id}/" name "${name}"
  gsettings set "${FOLDER_SCHEMA}:${FOLDER_BASE}/${id}/" translate false
  gsettings set "${FOLDER_SCHEMA}:${FOLDER_BASE}/${id}/" apps "[${apps%, }]"
}

folder Dev "Dev" \
  dev.zed.Zed.desktop \
  cursor.desktop \
  code.desktop \
  nvim.desktop \
  vim.desktop \
  micro.desktop \
  org.gnome.Meld.desktop \
  io.dbeaver.DBeaverCommunity.desktop \
  me.iepure.devtoolbox.desktop \
  com.github.marhkb.Pods.desktop \
  org.gnome.Boxes.desktop \
  virt-manager.desktop \
  de.wwwtech.gitte.desktop \
  com.jeffser.Alpaca.desktop \
  t3_code_alpha.desktop

folder Terminals "Terminals" \
  com.mitchellh.ghostty.desktop \
  Alacritty.desktop \
  kitty.desktop \
  org.gnome.Console.desktop \
  org.gnome.Terminal.desktop

folder Internet "Internet" \
  app.zen_browser.zen.desktop \
  firefox.desktop \
  brave-browser.desktop \
  helium.desktop \
  org.gnome.Epiphany.desktop \
  com.discordapp.Discord.desktop \
  com.transmissionbt.Transmission.desktop \
  de.haeckerfelix.Fragments.desktop \
  org.localsend.localsend_app.desktop \
  app.drey.Warp.desktop

folder Office "Office" \
  com.collaboraoffice.Office.desktop \
  com.logseq.Logseq.desktop \
  io.github.alainm23.planify.desktop \
  org.gnome.Calendar.desktop \
  org.gnome.Contacts.desktop \
  org.gnome.TextEditor.desktop \
  org.gnome.gedit.desktop \
  org.gnome.Evince.desktop \
  org.gnome.World.Secrets.desktop

folder Media "Media" \
  org.gnome.Showtime.desktop \
  org.gnome.Totem.desktop \
  org.gnome.Decibels.desktop \
  org.gnome.Music.desktop \
  org.gnome.Loupe.desktop \
  org.gnome.eog.desktop \
  org.gnome.Snapshot.desktop \
  com.rafaelmardojai.Blanket.desktop \
  page.kramo.Sly.desktop \
  io.github.wartybix.Constrict.desktop \
  com.github.unrud.VideoDownloader.desktop \
  org.nickvision.tubeconverter.desktop

# Games auto-collects anything with the Game category (Steam games etc.),
# plus the launchers themselves.
folder Games "Games" \
  steam.desktop \
  com.heroicgameslauncher.hgl.desktop \
  com.usebottles.bottles.desktop
gsettings set "${FOLDER_SCHEMA}:${FOLDER_BASE}/Games/" categories "['Game']"

folder System "System" \
  org.gnome.tweaks.desktop \
  org.gnome.Extensions.desktop \
  com.mattjakeman.ExtensionManager.desktop \
  io.missioncenter.MissionCenter.desktop \
  org.gnome.SystemMonitor.desktop \
  org.gnome.Usage.desktop \
  org.gnome.Logs.desktop \
  org.gnome.baobab.desktop \
  org.gnome.DiskUtility.desktop \
  org.gnome.PowerStats.desktop \
  btop.desktop \
  htop.desktop \
  btrfs-assistant.desktop \
  octopi.desktop \
  octopi-notifier.desktop \
  octopi-cachecleaner.desktop \
  octopi-repoeditor.desktop \
  org.cachyos.KernelManager.desktop \
  org.cachyos.scx-manager.desktop \
  cachyos-hello.desktop \
  cachyos-pi.desktop \
  org.gnome.World.PikaBackup.desktop \
  backintime-qt.desktop \
  org.gnome.Software.desktop \
  io.github.kolunmi.Bazaar.desktop \
  io.github.flattool.Warehouse.desktop \
  io.github.flattool.Ignition.desktop \
  it.mijorus.gearlever.desktop \
  nvidia-settings.desktop \
  org.pulseaudio.pavucontrol.desktop \
  kvantummanager.desktop \
  qt5ct.desktop

folder Utilities "Utilities" \
  org.gnome.Calculator.desktop \
  org.gnome.Characters.desktop \
  org.gnome.clocks.desktop \
  org.gnome.Weather.desktop \
  org.gnome.Maps.desktop \
  org.gnome.font-viewer.desktop \
  org.gnome.FileRoller.desktop \
  org.gnome.SimpleScan.desktop \
  org.gnome.Connections.desktop \
  com.belmoussaoui.Decoder.desktop \
  io.gitlab.adhami3310.Converter.desktop \
  io.gitlab.adhami3310.Impression.desktop \
  balena-etcher.desktop \
  be.alexandervanhee.gradia.desktop \
  swappy.desktop \
  de.leopoldluley.Clapgrep.desktop \
  de.schmidhuberj.DieBahn.desktop \
  dev.bragefuglseth.Fretboard.desktop \
  org.gnome.Yelp.desktop

# Rarely used stuff that would otherwise clutter the top level.
folder Misc "Misc" \
  assistant.desktop \
  designer.desktop \
  linguist.desktop \
  qdbusviewer.desktop \
  cmake-gui.desktop \
  electron37.desktop \
  avahi-discover.desktop \
  bssh.desktop \
  bvnc.desktop \
  gnome-nettool.desktop \
  nm-connection-editor.desktop \
  cups.desktop \
  system-config-printer.desktop \
  hplip.desktop \
  hp-uiscan.desktop \
  backintime-qt-root.desktop \
  lstopo.desktop \
  qv4l2.desktop \
  qvidcap.desktop \
  rofi.desktop \
  rofi-theme-selector.desktop \
  org.kde.dolphin.desktop \
  kdesystemsettings.desktop \
  org.kde.kdeconnect.app.desktop \
  org.kde.kdeconnect.nonplasma.desktop \
  org.kde.kdeconnect.sms.desktop \
  org.freedesktop.MalcontentControl.desktop \
  org.gnome.Tour.desktop \
  uuctl.desktop \
  xgps.desktop \
  xgpsspeed.desktop

gsettings set org.gnome.desktop.app-folders folder-children \
  "['Dev', 'Terminals', 'Internet', 'Office', 'Media', 'Games', 'System', 'Utilities', 'Misc']"

# Drop any manually dragged icon positions so folders sort alphabetically
# into a clean grid.
gsettings reset org.gnome.shell app-picker-layout

echo "GNOME app folders applied."
