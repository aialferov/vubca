all:
	vagrant up

reboot:
	vagrant reload

clean:
	vagrant destroy -f

ssh:
	vagrant ssh -- -l casper

wake:
	vagrant resume

sleep:
	vagrant suspend
