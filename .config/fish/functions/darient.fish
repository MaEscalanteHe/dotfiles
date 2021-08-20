function __darient_discord
  set -l DISCORD_CONFIG_DIR $HOME/Workspace/Darient/.discord

  set -l CONFIG_DIR $DISCORD_CONFIG_DIR/config
  set -l TMP_DIR $DISCORD_CONFIG_DIR/tmp

  [ ! -d "$DISCORD_CONFIG_DIR" ] && mkdir $DISCORD_CONFIG_DIR
  [ ! -d "$CONFIG_DIR" ] && mkdir $CONFIG_DIR
  [ ! -d "$TMP_DIR" ] && mkdir $TMP_DIR

  /bin/bash -c "export XDG_CONFIG_HOME=$CONFIG_DIR; export TMPDIR=$TMP_DIR; /opt/discord/Discord 2>&1 > /dev/null" 2>&1 > /dev/null &
  disown
end

function __darient_vpn
  sudo openfortivpn 186.72.79.163:10443 -u darien -p Panama2021- --trusted-cert 58e57e725e21303d2a68e6804bc5a5edc7f7133bca191623a6e2903b447991f0
end

function darient
  argparse \
  'd/discord' \
  'v/vpn'\
  -- $argv
  or return

  # Discord.
  if set -q _flag_discord
    __darient_discord
  end

  # VPN.
  if set -q _flag_vpn
    __darient_vpn
  end

  cd $HOME/Workspace/Darient
end
