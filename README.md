# devops_openshift

git clone 

editar inventory/inventory configurando nodos servidor nfs replicas

# ejecutar prerequisitos

ansible-playbook -f 8 -i inventory/inventory /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml

# instalar 

/usr/bin/ansible-playbook -f 8 -i inventory/inventory /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml

# Agregar nodo

https://docs.openshift.com/container-platform/3.3/install_config/adding_hosts_to_existing_cluster.html

## nodo app - infra

/usr/bin/ansible-playbook -f 8 -i inventory/inventory /usr/share/ansible/openshift-ansible/playbooks/byo/openshift-node/scaleup.yml

## nodo master

/usr/share/ansible/openshift-ansible/playbooks/byo/openshift-master/scaleup.yml

# CICD 

oc new-project cicd

oc create  -f template/pv-jenkins.yaml

oc process jenkins-persistent -n openshift | oc create -f - -n cicd

edit jenkins para que pueda ver el proyecto prueba  Jenkins - Configuración - OpenShift Jenkins Sync - Namespace 


# Test template ##

oc new-project prueba

oc create -f template/openjdk18-template-web-basic-s2i-jenkins.yaml -n prueba

oc process openjdk18-web-basic-s2i-pipeline -p NAMESPACE=prueba  | oc create -f - -n prueba
