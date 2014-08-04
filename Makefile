all:
	vagrant up

reboot:
	vagranat reload

clean:
	vagrant destroy -f

ssh:
	vagrant ssh -- -l casper

wake:
	vagrant resume

sleep:
	vagrant suspend
