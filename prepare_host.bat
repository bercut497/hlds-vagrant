cd %~dp0

    echo 'setup vagrant plugins'
#   vagrant plugin install vagrant-hosts
#   vagrant plugin install vagrant-rekey-ssh
    vagrant plugin install sahara
    vagrant plugin install vagrant-cachier
#   vagrant plugin install vagrant-vbguest
