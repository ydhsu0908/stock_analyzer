clean:
			\rm -rf Output/*
			mkdir output/
			mkdir Output/per_stock_info

all:
			perl get_capital_stock.pl
