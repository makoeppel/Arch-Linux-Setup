
.DEFAULT_GOAL := all

.ONESHELL :
SHELL := bash
.SHELLFLAGS := -euf -c

PREFIX := $(HOME)/.local
CMAKE_OPTS := -DCMAKE_INSTALL_PREFIX=$(PREFIX) -DCMAKE_BUILD_TYPE=Release

# clone git project and do stash/pull
# $(1) - git url
# $(2) - link
define clone_pull
	[ -e $(2)/.git ] || git clone -- $(1) $$(readlink -- $(2))
	git -C $(2) stash
	git -C $(2) pull
	git -C $(2) submodule update --init --recursive
endef

# generate cmake build system and do make/install
define cmake_make_install
	# dependencies: cmake, pkg-config
	cmake -S $(1) -B $(1)/build $(CMAKE_OPTS)
	$(MAKE) -C $(1)/build
	$(MAKE) -C $(1)/build install
endef

all :

.PHONY : oh-my-zsh
oh-my-zsh :
	$(call clone_pull,https://github.com/robbyrussell/oh-my-zsh,$@)

.PHONY : oh-my-vim
oh-my-vim :
	$(shell ./install_vim.sh)
