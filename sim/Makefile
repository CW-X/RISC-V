DUT := ../ver_component/DUT/RTL
VER := ../ver_component
RM_chip := ../ver_component/rm/rtl

FILELIST := filelist.f

$(FILELIST):
	echo "+incdir+$(DUT)/" > $(FILELIST)
	find $(DUT) -name "*.sv" -exec echo "{}" \; >> $(FILELIST)
	echo "+incdir+$(VER)/" >> $(FILELIST)
	find $(VER) -name "*.sv" -exec echo "{}" \; >> $(FILELIST)
	echo "+incdir+$(RM_chip)/" >> $(FILELIST)
	find $(RM_chip) -name "*.sv" -exec echo "{}" \; >> $(FILELIST)

	sort $(FILELIST) | uniq > $(FILELIST).tmp && mv $(FILELIST).tmp $(FILELIST)
	echo "Filelist generated: $(FILELIST)"

all: $(FILELIST)

clean:
	rm -f $(FILELIST)

