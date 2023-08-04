let
  pinwheel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMoI7Q4zT2AGXU+i8fLmzcNLdfMkEnfHYh4PmaEmo2QW root@pinwheel";
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILTw7VCV4z5At0e+oCG+3I3tSyhmLJgQkWlhaYJVlyS8 alex.bennu2@github.com";
in {
  "pinwheel/syncthing-cert.age".publicKeys = [ pinwheel alex ];
  "pinwheel/syncthing-key.age".publicKeys = [ pinwheel alex ];
}
