all:
	vagrant up

clean:
	vagrant destroy -f

ssh:
	vagrant ssh -- -l casper

wake:
	vagrant resume

sleep:
	vagrant suspend
