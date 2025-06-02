.PHONY: build clean_code clean_data clean generate_data

build:
	matlab -nodisplay -batch "setup"

generate_data:
	matlab -nodisplay -batch "generate_zurich_data"
	rm -f CalculationZH.mat

clean_code:
	# Backup excluded functions while preserving package structure
	mkdir -p wrapped_backup
	while read -r func; do \
		find wrapped -name "$${func}.m" -exec bash -c ' \
			pkg_path=$$(dirname "{}"); \
			rel_path=$${pkg_path#wrapped/}; \
			mkdir -p wrapped_backup/$$rel_path; \
			cp "{}" wrapped_backup/$$rel_path/ \
		' \; ; \
	done < excluded_functions.txt
	rm -rf wrapped
	# Restore excluded functions with package structure
	mkdir -p wrapped
	cp -r wrapped_backup/* wrapped/
	rm -rf wrapped_backup

clean_data:
	rm -rf +data_functions
	rm -rf data

clean: clean_code clean_data

all: build generate_data
