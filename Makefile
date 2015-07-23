USER := casper
SSH := vagrant ssh -- -A -l

all:
	vagrant up

reboot:
	vagrant reload

clean:
	vagrant destroy -f

update:
	$(SSH) $(USER) "sudo apt-get update && sudo apt-get upgrade -y"

ssh:
	$(SSH) $(USER)

wake:
	vagrant resume

sleep:
	vagrant suspend
