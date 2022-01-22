
SCRIPT_DIR=$$(pwd)/scripts

.PHONY: all
all: setup provision sync files

.PHONY: prepare
prepare: setup provision

.PHONY: continue
continue: files

.PHONY: setup
setup:
	@$(SCRIPT_DIR)/install-homebrew.sh
	@$(SCRIPT_DIR)/install-ansible.sh

.PHONY: provision
provision:
	@$(SCRIPT_DIR)/ansible-provision.sh

.PHONY: sync
sync:
	@$(SCRIPT_DIR)/open-dropbox.sh

.PHONY: files
files:
	@$(SCRIPT_DIR)/ansible-files.sh
