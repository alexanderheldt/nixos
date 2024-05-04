let
  # see `modules/age/default.nix` where these are defined
  pinwheel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMoI7Q4zT2AGXU+i8fLmzcNLdfMkEnfHYh4PmaEmo2QW root@pinwheel";
  sombrero = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO/NltCo1L+X1OIBfIKzfrbxLpCOerQ4vTIs+QPTXkf/ root@sombrero";
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjSFvlbdy5D59UaVWjRMyBndiAT2MtCeT+6GuemkuYe alex.pinwheel";
in {
  "pinwheel/syncthing-cert.age".publicKeys = [ pinwheel alex ];
  "pinwheel/syncthing-key.age".publicKeys = [ pinwheel alex ];
  "pinwheel/alex.pinwheel-sombrero.age".publicKeys = [ pinwheel alex ];
  "pinwheel/alex.pinwheel-sombrero.pub.age".publicKeys = [ pinwheel sombrero alex ];
  "pinwheel/alex.pinwheel-github.com.age".publicKeys = [ pinwheel alex ];
  "pinwheel/alex.pinwheel-github.com.pub.age".publicKeys = [ pinwheel alex ];
  "pinwheel/alex.pinwheel-andromeda.age".publicKeys = [ pinwheel alex ];
  "pinwheel/alex.pinwheel-andromeda.pub.age".publicKeys = [ pinwheel alex ];
  "pinwheel/alex.pinwheel-codeberg.org.age".publicKeys = [ pinwheel alex ];
  "pinwheel/alex.pinwheel-codeberg.org.pub.age".publicKeys = [ pinwheel alex ];

  "pinwheel/work-gitconfig.age".publicKeys = [ pinwheel alex ];
  "pinwheel/work-github-token.age".publicKeys = [ pinwheel alex ];
  "pinwheel/work-go-private.age".publicKeys = [ pinwheel alex ];
  "pinwheel/work-staging-ovpn.age".publicKeys = [ pinwheel alex ];
  "pinwheel/work-production-ovpn.age".publicKeys = [ pinwheel alex ];

  "sombrero/syncthing-cert.age".publicKeys = [ sombrero alex ];
  "sombrero/syncthing-key.age".publicKeys = [ sombrero alex ];
  "sombrero/alex.sombrero-github.com.age".publicKeys = [ sombrero alex ];
  "sombrero/alex.sombrero-github.com.pub.age".publicKeys = [ sombrero alex ];
  "pinwheel/alex.sombrero-codeberg.org.age".publicKeys = [ sombrero alex ];
  "pinwheel/alex.sombrero-codeberg.org.pub.age".publicKeys = [ sombrero alex ];
}
