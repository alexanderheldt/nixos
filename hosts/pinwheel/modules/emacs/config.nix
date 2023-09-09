{ emacs, runCommand, ...  }:
runCommand "default.el" {} ''
  cp ${./config.org} $TMPDIR/config.org
  cd $TMPDIR
  ${emacs}/bin/emacs --batch -Q \
                     -l org config.org \
                     -f org-babel-tangle

  mv config.el $out
  ''
