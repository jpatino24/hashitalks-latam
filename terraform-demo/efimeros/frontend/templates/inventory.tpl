[linux:vars]
timeout=60
ansible_ssh_common_args="-o StrictHostKeyChecking=no"

[linux:children]
lb

[lb]
%{ for ip in node_ip ~}
${ip}
%{ endfor ~}

[webservers]
%{ for ip in webs_ip ~}
${ip}
%{ endfor ~}