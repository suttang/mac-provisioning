.PHONY: all
all: setup provision sync files

.PHONY: setup
setup:
	@$(SCRIPT_DIR)/install-homebrew.sh
	@$(SCRIPT_DIR)/install-ansible.sh

