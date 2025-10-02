{pkgs, ...}: {
  programs.ssh.startAgent = false;

  environment.variables = {
    LD_LIBRARY_PATH = "/usr/lib/wsl/lib:$LD_LIBRARY_PATH";
    SSH_AUTH_SOCK = "/mnt/wsl/ssh-agent.sock";
  };

  systemd.user.services.ssh-agent-proxy = {
    description = "Windows SSH agent proxy";
    path = [pkgs.wslu pkgs.coreutils pkgs.bash];
    serviceConfig = {
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p /mnt/wsl"
        "${pkgs.coreutils}/bin/rm -f /mnt/wsl/ssh-agent.sock"
      ];
      ExecStart = "${pkgs.writeShellScript "ssh-agent-proxy" ''
                                        set -x  # Enable debug output

        # Get Windows username using wslvar
                                        WIN_USER="$("${pkgs.wslu}/bin/wslvar" USERNAME 2>/dev/null || echo $USER)"

        # Check common npiperelay locations
                                        NPIPE_PATHS=(
                                                        "/mnt/c/Users/$WIN_USER/AppData/Local/Microsoft/WinGet/Links/npiperelay.exe"
                                                        "/mnt/c/ProgramData/chocolatey/bin/npiperelay.exe"
                                                    )

                                        NPIPE_PATH=""
                                        for path in "''${NPIPE_PATHS[@]}"; do
                                                echo "Checking npiperelay at: $path"
                                                        if [ -f "$path" ]; then
                                                                NPIPE_PATH="$path"
                                                                        break
                                                                        fi
                                                                        done

                                                                        if [ -z "$NPIPE_PATH" ]; then
                                                                                echo "npiperelay.exe not found in expected locations!"
                                                                                        exit 1
                                                                                        fi

                                                                                        echo "Using npiperelay from: $NPIPE_PATH"

                                                                                        exec ${pkgs.socat}/bin/socat -d UNIX-LISTEN:/mnt/wsl/ssh-agent.sock,fork,mode=600 \
                                                                                        EXEC:"$NPIPE_PATH -ei -s //./pipe/openssh-ssh-agent",nofork
      ''}";
      Type = "simple";
      Restart = "always";
      RestartSec = "5";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    wantedBy = ["default.target"];
  };

  systemd.user.services.ssh-agent-proxy.serviceConfig.RuntimeDirectory = "ssh-agent";
}
