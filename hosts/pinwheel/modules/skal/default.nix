{ pkgs, lib, config, ... }:
let
  skalPath = config.mod.skal.path;

  skal =
    if skalPath == "" then
      throw "'skal.path' cannot be empty"
   else
     pkgs.writeShellScriptBin "skal" ''
       URL=`git config --get remote.origin.url`
       GITHOST=`echo $URL | sed -e s/.*@// | sed -e s/:.*//`
       GITPATH=`echo $URL | sed -e s/.*:// | sed -e s/.git$//`

       FLAKE_DIR="${skalPath}/$GITHOST/$GITPATH"

       if [ "$1" == "create" ]; then
         if [ ! -d "$FLAKE_DIR" ]; then
           echo Creating flake "$FLAKE_DIR"
           mkdir -p "$FLAKE_DIR"
           FLAKE="$FLAKE_DIR"/flake.nix
           cp ${./flake-template.nix} "$FLAKE"
           chmod 700 "$FLAKE"
           ${pkgs.vim}/bin/vim "$FLAKE"
           exit 0
         else
           echo Flake already exist
         fi
       fi

       if [ ! -d $FLAKE_DIR ]; then
         echo No flake exist for "$FLAKE_DIR"
         exit 1
       fi

       echo Using "$FLAKE_DIR"
       nix develop $FLAKE_DIR $*
     '';
in
{
  options = {
    mod.skal = {
      path = lib.mkOption {
        description = "path to where all flake.nix reside";
        type = lib.types.str;
        default = "";
      };
    };
  };

  config = {
    home-manager.users.alex = {
      home.packages = [ skal ];
    };
  };
}
