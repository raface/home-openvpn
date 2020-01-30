openvpn (){
case "$1" in
  media)
    if docker ps | grep -v grep | grep "vpn-media" > /dev/null 2>&1; then
      printf "Using VPN Docker. \n";
    else
      printf "Starting VPN Docker \n";
      docker build --force-rm -t openvpn /home/rafael/vpn/openvpn/
      docker run -d --name vpn-media --rm -i -t --privileged --sysctl net.ipv6.conf.all.disable_ipv6=0 -p 127.0.0.1:4444:22 -e "SSH_KEY=$(cat ~/.ssh/id_rsa.pub)" openvpn
      sleep 3
    fi
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -f -L 4447:media.domirete:22 -p 4446 root@localhost sleep 10 && ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 4447 developer@localhost
    ;;
  media1)
    if docker ps | grep -v grep | grep "vpn-media1" > /dev/null 2>&1; then
      printf "Using VPN Docker. \n";
    else
      printf "Starting VPN Docker \n";
      docker build --force-rm -t openvpn /home/rafael/vpn/openvpn/
      docker run -d --name vpn-media1 --rm -i -t --privileged --sysctl net.ipv6.conf.all.disable_ipv6=0 -p 127.0.0.1:4446:22 -e "SSH_KEY=$(cat ~/.ssh/id_rsa.pub)" openvpn
      sleep 3
    fi
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -f -L 4445:media1.domirete:22 -p 4444 root@localhost sleep 10 && ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 4445 rock64@localhost
    ;;
  web)
    if docker ps | grep -v grep | grep "openvpn" > /dev/null 2>&1; then
      printf "Using VPN Docker. \n";
    else
      printf "Starting VPN Docker \n";
      docker build --force-rm -t openvpn /home/rafael/vpn/openvpn/
      docker run -d --name vpnweb --rm -i -t --privileged --sysctl net.ipv6.conf.all.disable_ipv6=0 -p 127.0.0.1:4444:22 -e "SSH_KEY=$(cat ~/.ssh/id_rsa.pub)" openvpn
      sleep 3
    fi
    ssh -o ExitOnForwardFailure=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -f -D 8080 -p 4444 root@localhost sleep 10 && chromium-browser --user-data-dir=$(mktemp -d) --proxy-server="socks5://localhost:8080" http://portainer.media.domirete --incognito > /dev/null 2>&1
    ;;
  down)
     docker stop vpn-media vpn-media1 vpnweb
     ;;
  status)
        if docker ps | grep -v grep | grep "openvpn" > /dev/null 2>&1; then printf "VPN is up! \n"; else printf "VPN is down! \n"; fi
        ;;
  *)
        printf "Invalid option.\n"
        ;;
esac
}
