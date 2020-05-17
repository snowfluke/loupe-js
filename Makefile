WEBPACK := yarn webpack-cli
SASS := yarn sass

.PHONY: default
default:
	@echo "the default target does nothing!"

.PHONY: dev
dev: clean
	$(WEBPACK) --mode=development --watch

.PHONY: dist
dist: clean
	$(SASS) --no-source-map --style=compressed src/style.scss dist/style.css
	$(WEBPACK) --no-color --mode=production

.PHONY: clean
clean:
	rm -rf dist

.PHONY: fmt
fmt:
	# tsfmt
	find . -type f \( -name '*.ts' -o -name '*.tsx' \) \
		! -name '*.d.ts' \
		! -regex '.*/node_modules/.*' | \
		xargs yarn tsfmt --replace

.PHONY: copyjs-demo
copyjs-demo:
	$(WEBPACK) --mode=development
	# Copy development dist.js (non-minified) to demo/ and add the following line
	#   window.loupe = exports;
	# in an appropriate place.
	#
	# https://unix.stackexchange.com/questions/121161/how-to-insert-text-after-a-certain-string-in-a-file
	awk '1;/var px = function/{ print "window.loupe = exports;" }' dist/index.js > demo/index.js
