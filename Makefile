all:
	vagrant up
	vagrant reload # kernel update requires reboot
	               # but reboot from within OS destroys synced folder

clean:
	vagrant destroy -f

ssh:
	vagrant ssh -- -l casper

wake:
	vagrant resume

sleep:
	vagrant suspend
