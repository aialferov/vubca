# vim: noet

SSH := vagrant ssh -- -A -l

all:
	vagrant up
	vagrant reload
	vagrant ssh -- "sudo apt-get autoremove -y"

reboot:
	vagrant reload

clean:
	vagrant destroy -f

update:
	vagrant ssh -- "\
		sudo apt-get update && \
		sudo apt-get upgrade -y && \
		sudo apt-get dist-upgrade -y\
	"
ssh:
	$(SSH) $$(whoami)

ssh-%:
	$(SSH) $*

wake:
	vagrant resume

sleep:
	vagrant suspend
