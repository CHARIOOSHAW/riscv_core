.PHONY : cmp verdi all clean

# name defines
OUTPUT     =  simv_riscv_core
FILE_LIST  =  ~/shaw/riscv_core/filelist/filelist.f
LOG_DIR    =  ~/shaw/riscv_core/log
INC_DIR    =  ../source
SIM_DIR    =  ~/shaw/riscv_core/sim
TOP_MODULE =  core_top

# code coverage command
CM         = -cm line+cond+fsm+branch+tgl
CM_NAME    = -cm_name $(OUTPUT)
CM_DIR     = -cm_dir $(SIM_DIR)/$(OUTPUT).vdb

# vdp file name
VPD_NAME   = +vpdfiles+$(OUTPUT).vpd

#compile command
VCS = vcs -R \
			   	+lint=TFIPC-L\
          -full64 \
          -sverilog +v2k -timescale=1ns/1ns \
					-debug_access \
					-debug_region=cell+lib \
					-debug_all \
					+notimingchec \
					+nospecify \
					+vcs+flush+all \
					-fsdb \
					-kdb \
					-lca \
					+define+FSDB \
					+incdir+$(INC_DIR) \
					-o $(SIM_DIR)/$(OUTPUT) \
          -f $(FILE_LIST) \
					-l $(LOG_DIR)/compile.log
					## $(CM) 
		  		## $(CM_NAME) 
		  		## $(CM_DIR) 

# simulation command
SIM =  $(SIM_DIR)/$(OUTPUT) \
    -l $(LOG_DIR)/$(OUTPUT).log
 		## $(CM) $(CM_NAME) $(CM_DIR)        

VERDI = verdi -2001 \
							-f $(FILE_LIST) \
              -top $(TOP_MODULE) 

# start compile
cmp: 
	$(VCS)
	cp -r ./* ../sim
	rm -r ./*
	cp -r ../sim/makefile ./

# start simulation
verdi:
	cp -r ../source/mcu_defines.v ./
	cp -r ../source/config.v ./
	$(VERDI)
	cp -r ./* ../sim
	rm -r ./*
	cp -r ../sim/makefile ./

# cmp and verdi
all:
	$(VCS)
	cp -r ./* ../sim
	rm -r ./*
	cp -r ../sim/makefile ./
	cp -r ../source/mcu_defines.v ./
	cp -r ../source/config.v ./
	$(VERDI)
	cp -r ./* ../sim
	rm -r ./*
	cp -r ../sim/makefile ./

# clean
clean:
	rm -r $(SIM_DIR)
	mkdir ../sim
