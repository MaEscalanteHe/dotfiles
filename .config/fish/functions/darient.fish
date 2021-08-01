function __darient_discord
  set -l DISCORD_CONFIG_DIR $HOME/Workspace/Darient/.discord

  set -l CONFIG_DIR $DISCORD_CONFIG_DIR/config
  set -l TMP_DIR $DISCORD_CONFIG_DIR/tmp

  [ ! -d "$CONFIG_DIR" ] && mkdir $CONFIG_DIR
  [ ! -d "$TMP_DIR" ] && mkdir $TMP_DIR

  /bin/bash -c "export XDG_CONFIG_HOME=$CONFIG_DIR; export TMPDIR=$TMP_DIR; /opt/discord/Discord 2>&1 > /dev/null" 2>&1 > /dev/null &
  disown
end

function darient
  argparse \
  'd/discord' \
  -- $argv
  or return

  # Discord.
  if set -q _flag_discord
    __darient_discord
  end

  cd $HOME/Workspace/Darient
end
