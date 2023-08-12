let
  pinwheel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMoI7Q4zT2AGXU+i8fLmzcNLdfMkEnfHYh4PmaEmo2QW root@pinwheel";
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjSFvlbdy5D59UaVWjRMyBndiAT2MtCeT+6GuemkuYe alex.pinwheel";
in {
  "pinwheel/syncthing-cert.age".publicKeys = [ pinwheel alex ];
  "pinwheel/syncthing-key.age".publicKeys = [ pinwheel alex ];
  "pinwheel/alex.pinwheel-github.com.age".publicKeys = [ pinwheel alex ];
  "pinwheel/alex.pinwheel-github.com.pub.age".publicKeys = [ pinwheel alex ];
}
