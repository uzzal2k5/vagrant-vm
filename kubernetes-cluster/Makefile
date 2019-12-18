.PHONY: all builder create vagrant vm
.SILENT:

init:
	@echo Running Vagrant...
	 vagrant up ||true

# delete created files
clean:
	@echo Running Clean...
	# TODO: technically, the 'true' should check if all the files are rm-ed
	vagrant destroy -f  || true
# vim: ts=8