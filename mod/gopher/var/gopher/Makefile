install:
	rm -f [!M]*
	for x in /var/www/htdocs/*; do ln -s $$x/current $${x##*/}; done
	ln -s josuah/index.gph .
