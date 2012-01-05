#!/bin/bash

echo '# dyndns' > multisite_names.txt
bin/dyndns.pl

echo '# no-ip' >> multisite_names.txt
bin/no-ip.pl
