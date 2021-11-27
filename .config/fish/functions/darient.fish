function __darient_discord
  set -l DISCORD_CONFIG_DIR $HOME/Workspace/Darient/.discord

  set -l CONFIG_DIR $DISCORD_CONFIG_DIR/config
  set -l TMP_DIR $DISCORD_CONFIG_DIR/tmp
  set -l DISCORD_APP (which discord)

  [ ! -d "$DISCORD_CONFIG_DIR" ] && mkdir $DISCORD_CONFIG_DIR
  [ ! -d "$CONFIG_DIR" ] && mkdir $CONFIG_DIR
  [ ! -d "$TMP_DIR" ] && mkdir $TMP_DIR

  /bin/bash -c "export XDG_CONFIG_HOME=$CONFIG_DIR; export TMPDIR=$TMP_DIR; $DISCORD_APP 2>&1 > /dev/null" 2>&1 > /dev/null &
  disown
end

function __darien_vpn
  sudo openfortivpn -c /etc/openfortivpn/darien
end

function __esilva_vpn
  sudo openfortivpn -c /etc/openfortivpn/esilva
end

function darient
  argparse \
  'd/discord' \
  'v/vpn-darien'\
  'V/vpn-esilva'\
  -- $argv
  or return

  # Discord.
  if set -q _flag_discord
    __darient_discord
  end

  # VPN (darien user)
  if set -q _flag_vpn_darien
    __darien_vpn
  end

  # VPN (esilva user)
  if set -q _flag_vpn_esilva
    __esilva_vpn
  end

  cd $HOME/Workspace/Darient
end
