GITBOOK = node_modules/.bin/gitbook
RUSTC = rustc
STRICT = -D deprecated
QUIET = -A unused-variables -A dead-code -A unused-assignments
RUSTC_NT = $(RUSTC) -Z no-trans --test $(QUIET) ${STRICT}
WHITELIST = examples/attribute/cfg/custom/custom.rs \
            examples/borrow/borrow.rs \
            examples/borrow/freeze/freeze.rs \
            examples/borrow/mut/mut.rs \
            examples/bounds/bounds.rs \
            examples/constants/constants.rs \
            examples/crates/link/executable.rs \
            examples/lifetime/borrow/borrow.rs \
            examples/mod/mod.rs \
            examples/print/print.rs \
            examples/type/cast/cast.rs \
            examples/type/type.rs \
            examples/variable_bindings/scope/scope.rs \
            examples/variable_bindings/mut/mut.rs \
            examples/variable_bindings/declare/declare.rs \
            examples/vec/vec.rs

srcs = $(filter-out $(WHITELIST),$(shell find examples -name '*.rs'))

.PHONY: all book clean test serve

all:
	./setup-stage.sh
	cargo run

book: node_modules/gitbook
	$(GITBOOK) build stage
	./fix-edit-button.sh
	./add-relinks.sh

clean:
	rm -rf bin stage

test:
	@$(foreach src,$(srcs),$(RUSTC_NT) $(src) || exit;)
	./check-line-length.sh
	./check-links.sh

serve: node_modules/gitbook
	$(GITBOOK) serve stage

node_modules/gitbook:
	npm install gitbook@1.5.0
