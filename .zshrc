# zsh config: optional oh-my-zsh, then the shared aliases/env from .bashrc
# of this repository (found by resolving the ~/.zshrc symlink).
DOTFILES=${${(%):-%N}:A:h}

if [ -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
    export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
    ZSH_THEME="robbyrussell"
    plugins=(git)
    source "$ZSH/oh-my-zsh.sh"
fi

# distro-packaged plugins (Arch: /usr/share/zsh/plugins, Fedora: /usr/share/<name>)
for _p in zsh-autosuggestions zsh-syntax-highlighting; do
    for _f in /usr/share/zsh/plugins/$_p/$_p.zsh /usr/share/$_p/$_p.zsh; do
        [ -r "$_f" ] && { source "$_f"; break; }
    done
done
unset _p _f

source "$DOTFILES/.bashrc"
