# `config-manager`
`./config-manager` is a module that contains a script to make usage
of this flake easier.

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

