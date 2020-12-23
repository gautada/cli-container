# cluster

A linux container that holds the various client applications and entry point into the Prometheus Kubernetes cluster.

The cluster is based on Alpine Linux

 - [Alpine Linux Packages|https://pkgs.alpinelinux.org/packages]


## Configuration

The default configuration should follow the XDG configuration guideline https://wiki.archlinux.org/index.php/XDG_Base_Directory

## Use Cases

### Development

1. Pre-Defined fully configured portable development environment

### Single Admin Interface

1. A single ssh login that can access the cluster

### Pre-Configured Clients

kubectl
docker
git
redis
psql
ansible

### Multiple screens

https://linuxize.com/post/how-to-use-linux-screen/
https://linuxhint.com/tmux_vs_screen/


- Use the linux gnu screen utility
CTRL-A D  -- Detach
Ctrl-A ?  -- Key Bindings


Ctrl+a c Create a new window (with shell)
Ctrl+a " List all window
Ctrl+a 0 Switch to window 0 (by number )
Ctrl+a A Rename the current window
Ctrl+a S Split current region horizontally into two regions
Ctrl+a | Split current region vertically into two regions
Ctrl+a tab Switch the input focus to the next region
Ctrl+a Ctrl+a Toggle between the current and previous region
Ctrl+a Q Close all regions but the current one
Ctrl+a X Close the current region

To-Do:

make the setup follow the xdg configuration







> cat ./cluster/README.md.save                                                                                                                    7:07PM (0s)
# cluster

A linux container that holds the various client applications and entry point into the Prometheus Kubernetes cluster.

The cluster is based on Alpine Linux

 - [Alpine Linux Packages|https://pkgs.alpinelinux.org/packages]


## Configuration

The default configuration should follow the XDG configuration guideline https://wiki.archlinux.org/index.php/XDG_Base_Directory

## Use Cases

### Development

1. Pre-Defined fully configured portable development environment

### Single Admin Interface

1. A single ssh login that can access the cluster

### Pre-Configured Clients
### Multiple screens

To-Do:

make the setup follow the xdg configuration
https://thevaluable.dev/zsh-install-configure/
