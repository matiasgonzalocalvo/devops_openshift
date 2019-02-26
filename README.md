# devops_openshift

# git clone 

#editar inventory/inventory configurando nodos servidor nfs replicas

#ejecutar prerequisitos

ansible-playbook -f 8 -i inventory/inventory /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml

# instalar 

/usr/bin/ansible-playbook -f 8 -i inventory/inventory /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml

#Agregar nodo
https://docs.openshift.com/container-platform/3.3/install_config/adding_hosts_to_existing_cluster.html
nodo app - infra
/usr/bin/ansible-playbook -f 8 -i inventory/inventory /usr/share/ansible/openshift-ansible/playbooks/byo/openshift-node/scaleup.yml
nodo master
/usr/share/ansible/openshift-ansible/playbooks/byo/openshift-master/scaleup.yml


# Test template ##

oc new-project prueba
oc create -f template/openjdk18-template-web-basic-s2i-jenkins.yaml
oc process openjdk18-web-basic-s2i-pipeline -p NAMESPACE=prueba  | oc create -f -
