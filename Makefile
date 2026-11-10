DIR := instalacoes_e_codigo
SRC := arkanoid_jose_pereira

.PHONY: build run clean

build:
	cd $(DIR) && ./p3as-linux $(SRC).as

run: build
	cd $(DIR) && java -jar p3sim.jar $(SRC).exe

clean:
	rm -f $(DIR)/$(SRC).exe
