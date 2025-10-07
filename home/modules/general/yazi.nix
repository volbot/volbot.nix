{
...
}:
{
  programs.yazi = {
    enable = true;
    keymap = {
      mgr.prepend_keymap = [
        # ripdrag (drag-n-drop) capabilities
        {
          on = [ "<C-o>" ];
          run = "shell -- ripdrag --no-click --and-exit --icon-size 64 --target --all \"$@\" | while read filepath; do cp -nR \"$filepath\" .; done";
          #desc = "drag-n-drop files to and from Yazi";
        }
        {
          on = [ "<C-O>" ];
          run = "shell -- ripdrag --no-click --and-exit --icon-size 64 --target --all \"$@\" | while read filepath; do cp -fR \"$filepath\" .; done";
          #desc = "drag-n-drop files to and from Yazi (with clobber)";
        }
      ];
    };
  };
}
