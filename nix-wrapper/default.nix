{ pkgs, lib, config, ... }:
let
  flakesPath = config.nix-wrapper.flakesPath;

  nix-wrapper =
    if flakesPath == "" then
      throw "'nix-wrapper.flakesPath' cannot be empty"
   else
     pkgs.writeShellScriptBin "nix-wrapper" ''
       URL=`git config --get remote.origin.url`
       GITHOST=`echo $URL | sed -e s/.*@// | sed -e s/:.*//`
       GITPATH=`echo $URL | sed -e s/.*:// | sed -e s/.git$//`
       FLAKE_PATH="${flakesPath}/$GITHOST/$GITPATH"

       usage() {
          cat << EOF
Usage:
  nix-wrapper [options]

Options:
  -c                create a flake.nix for the current path
  -e                edit the flake.nix for the current path
  -a <attribute>    target a specific attribute
EOF
        }

       create() {
         if [ -d "$FLAKE_PATH" ]; then
           echo "flake.nix already exist at $FLAKE_PATH"
           exit 1
         fi

         PWD=$(pwd)
         echo "Creating flake.nix in '$FLAKE_PATH' using '$PWD' as source path"
         mkdir -p "$FLAKE_PATH"

         FLAKE="$FLAKE_PATH"/flake.nix
         cp ${./flake-template.nix} "$FLAKE"
         chmod 700 "$FLAKE"
         sed -i -e "s|./SRC_PATH|$PWD|" "$FLAKE"

         $EDITOR "$FLAKE"
       }

       edit() {
         if [ ! -d "$FLAKE_PATH" ]; then
           echo "no flake.nix exist for '$FLAKE_PATH'"
           exit 1
         fi

         $EDITOR "$FLAKE_PATH/flake.nix"
       }

       [ "$#" -eq 0 ] && usage && exit 0

       ATTR=""
       while getopts "cea:" opt; do
         case "$opt" in
           c)
             create
             exit 0 ;;
           e)
             edit
             exit 0 ;;
           a)
             ATTR="$OPTARG" ;;
         esac
       done

       shift "$((OPTIND-1))"

       if [ ! -d "$FLAKE_PATH" ]; then
         echo "no flake.nix exist for '$FLAKE_PATH'"
         exit 1
       fi

       [ -n "$ATTR" ] && FLAKE_PATH="$FLAKE_PATH#$ATTR"
       nix $@ "$FLAKE_PATH"
     '';
in
{
  options = {
    nix-wrapper = {
      flakesPath = lib.mkOption {
        description = "path to where all flake.nix reside";
        type = lib.types.str;
        default = "";
      };
    };
  };

  config = {
    environment = {
      shellAliases = {
        nw = "${nix-wrapper}/bin/nix-wrapper";
      };

      systemPackages = [ nix-wrapper ];
    };
  };
}
