# Valenix

A basic wrapper around [vale](https://github.com/errata-ai/vale) with all the styles in the nix store.

```
nix run github:GuilloteauQ/valenix myfile.md
```

or add `valenix` to your registry:

```
nix registry add valenix https://github.com/GuilloteauQ/valenix
```

and then run it like:

```
nix run valenix myfile.md
```
