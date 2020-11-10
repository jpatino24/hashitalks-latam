[linux:vars]
timeout=60
ansible_ssh_common_args="-o StrictHostKeyChecking=no"

[linux:children]
webservers

[webservers]
%{ for ip in node_ip ~}
${ip}
%{ endfor ~}
