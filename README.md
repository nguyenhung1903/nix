# NixOS

Personal configuration for **NixOS**, **Home Manager**, and common development tools.

## Structure

```text
.
├── dotfiles/
│   ├── alacritty/
│   ├── ghostty/
│   ├── nvim/
│   └── tmux/
│
├── nixos/
│   ├── flake.nix
│   ├── flake.lock
│   ├── home/
│   │   └── nguyenhung1903/
│   ├── hosts/
│   │   └── nixos/
│   │       ├── configuration.nix
│   │       ├── hardware-configuration.nix
│   │       └── modules/
│   │           └── zsh.nix
│
├── notes/
│   └── first-note.md
│
└── update.sh
```

## Usage

Check configuration:

```bash
nix flake check ./nixos
```

Apply NixOS configuration:

```bash
sudo nixos-rebuild switch --flake ./nixos#nixos
```

Update Flake inputs:

```bash
nix flake update ./nixos
```

## Components

* **NixOS** — system configuration
* **Home Manager** — user environment
* **Zsh** — shell configuration
* **Neovim** — editor
* **Ghostty / Alacritty** — terminals
* **Tmux** — terminal multiplexer
* **OBS + NVIDIA** — recording configuration

