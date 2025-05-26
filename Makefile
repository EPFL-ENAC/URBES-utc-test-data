.PHONY: build clean_code clean_data clean generate_data

build:
	matlab -nodisplay -batch "setup"

generate_data:
	matlab -nodisplay -batch "generate_zurich_data"
	rm -f CalculationZH.mat

clean_code:
	rm -rf wrapped

clean_data:
	rm -rf +data_functions
	rm -rf data

clean: clean_code clean_data

all: build generate_data
