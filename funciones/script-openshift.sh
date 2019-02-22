#!/bin/bash
oc=$(which oc)
crear_build_from_file ()
{
	while (( "$#" )); do
		case $1 in 
			-d|--docker-image)
				docker_img=${2}
				shift
			;;
			-a|--app_name)
				app_name=${2}
				shift
			;;
			-s|--strategy)
				strategy=${2}
				shift
			;;
			-n|--namespace)
                                namespace=${2}
                                shift
                        ;;
			--directory)
				directory=${2}
				shift
			;;
			*)
				f_exit 0
			;;
		esac
		shift
	done
	f_check_var_exist "${docker_img}" docker_img
	f_check_var_exist "${app_name}" app_name
	f_check_var_exist "${strategy}" strategy
	f_check_var_exist "${namespace}" namespace
#	oc new-build redhat-openjdk18-openshift:1.2 --name=myjavaapp --strategy=source --binary
	if [ $(oc get buildconfig 2>&1|grep "^${app_name}"|wc -l) -eq 0 ] ; then
		oc new-build ${docker_img} --name=${app_name} --strategy=${strategy} --binary -n "${namespace}"
		f_check_error ${?} "CRITICAL NO PUDE CREAR EL BUILD APP ${1}"
	else
		f_muestra "buildconfig ya existe no se crea el build"
	fi
	if [ $(oc get build  2>&1|grep "^${app_name}"|wc -l) -eq 0 ] ; then
#		oc start-build example-app  --from-file=example-java-app/ROOT.war --follow
		oc start-build ${app_name} --from-file=${directory}/ROOT.jar --follow
		f_check_error ${?} "CRITICAL NO PUDE EJECUTAR EL start-build ${1}"
	else
		f_muestra "ya se hizo un start-buil no lo vuelvo a tirar para ejecutarlo ir a jenkins"
	fi
	if [ $(oc get deploymentconfig 2>&1|grep "^${app_name}"|wc -l) -eq 0 ] ; then
		oc new-app ${app_name}
		f_check_error ${?} "CRITICAL NO PUDE CREAR EL NEW APP ${1}"
	else
		f_muestra "ya existe la app no se vuelve a crear"
	fi
	if [ $(oc get route.route.openshift.io 2>&1|grep "^${app_name}"|wc -l) -eq 0 ] ; then
		oc expose svc/example-app
		f_check_error ${?} "CRITICAL NO PUDE EXPONER LA APP ${1}"
	else
		f_muestra "ya esta expuesta la app"
	fi
}
f_check_project_exist ()
{
	if [ $(${oc} projects -q|grep "^${1}$"|wc -l) -eq 0 ] ; then
		oc new-project ${1}
		f_check_error ${?} "CRITICAL NO PUDE CREAR EL PROYECTO ${1}"
	else
		f_muestra "El proyecto ${1} ya existe"
	fi
}
