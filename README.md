# `config-manager`
`./config-manager` is a module that contains a script to make usage of this flake easier.

To install it 
1. first add the module to the nixOS system connfiguration
2. set `config-manager.flakePath = <path to this flake>`
3. set `config-manager.system = <system type for the machine>`
4. run `nixos-rebuild switch --flake .#<configuration>`
after that `cm` will be available on `$PATH`.

# Secrets
Secrets are managed by `agenix` (https://github.com/ryantm/agenix).

## Creating new secrets
1. Update `secrets/secrets.nix` with the new secret.

2. When inside `./secrets`:
```
EDITOR=vim agenix -e "some-secret.age"
```

This will create a new secret. To view its content one can do:
```
EDITOR=vim agenix -d "some-secret.age" -i ~/.ssh/alex.pinwheel
```

Or use some other SSH key that is has been used to key the secret.

