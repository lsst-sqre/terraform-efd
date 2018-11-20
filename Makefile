UNAME := $(shell uname -s | tr A-Z a-z)
BIN_DIR = bin
DL_DIR = downloads
ARCH = amd64
TF_PLUG_DIR := .terraform/plugins/$(UNAME)_$(ARCH)

TF_VER = 0.11.10
TF_ZIP_FILE := terraform_$(TF_VER)_$(UNAME)_$(ARCH).zip
TF_ZIP_DL := $(DL_DIR)/$(TF_ZIP_FILE)
TF_BIN := $(BIN_DIR)/terraform

.PHONY: all test
all: tf-install
test: tf-test

# $< may not be defined because of |
$(TF_BIN): | $(TF_ZIP_DL)
	unzip -d $(BIN_DIR) $(TF_ZIP_DL)

$(TF_ZIP_DL): | $(DL_DIR)
	wget -nc https://releases.hashicorp.com/terraform/$(TF_VER)/$(TF_ZIP_FILE) -O $@

$(BIN_DIR) $(DL_DIR) $(TF_PLUG_DIR):
	mkdir -p $@

.PHONY: tf-install
tf-install: $(TF_BIN)

.PHONY: tf-init
tf-init: tf-install
	$(TF_BIN) init \
		-backend=false \
		-upgrade=true \
		-get=true

.PHONY: tf-test
tf-test: tf-init tf-fmt tf-validate

.PHONY: tf-fmt
tf-fmt:
	$(TF_BIN) fmt --check=true --diff=true

.PHONY: tf-validate
tf-validate:
	$(TF_BIN) validate --check-variables=false

.PHONY: clean
clean:
	-rm -rf $(BIN_DIR)
