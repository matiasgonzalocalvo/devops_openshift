#!/bin/bash
for i in $(ls funciones/*) ; do
	source $i
done
leer_parametros () 
{
	while (( "$#" )); do
                case $1 in
                        -d|--directory)
                                directory=${2}
                                shift
                        ;;
                        -h|--homologacion)
                                ambiente="homologacion"
                                shift
                        ;;
			-p|--produccion)
                                ambiente="produccion"
                                shift
                        ;;
			-d|--desarrollo)
                                ambiente="desarrollo"
                                shift
                        ;;
                        *)
				f_muestra "parametro no soportado == $1"
                                f_exit 0
                        ;;
                esac
                shift
        done	
	f_check_var_exist "${directory}" directory 
	f_check_var_exist "${ambiente}" ambiente
}
f_set_ambiente ()
{
	if [ "${1}" == "produccion" ] ; then
	        ambiente="${proyecto_produccion}"
	#       crear_app_from_docker -d "${docker_image}" -a "${app_name}" -s "${strategy}" -n ${proyecto_produccion}
	elif [ "${1}" == "homologacion" ] ; then
	        ambiente="${proyecto_homologacion}"
	#       crear_app_from_docker -d "${docker_image}" -a "${app_name}" -s "${strategy}" -n ${proyecto_homologacion}
	elif [ "${1}" == "desarrollo" ] ; then
	        ambiente="${proyecto_desarrollo}"
	#       crear_app_from_docker -d "${docker_image}" -a "${app_name}" -s "${strategy}" -n ${proyecto_desarrollo}
	else
	        muestra "CRITICAL"
	fi
}
#Leer parametros
leer_parametros $@
#Cargo Variables
environment="${directory}/environment"
f_cargar_environment ${environment}
#Chequeos que las variables necesarias existan
f_check_var_exist "${docker_image}" docker_image
f_check_var_exist "${app_name}" app_name
f_check_var_exist "${strategy}" strategy
f_check_var_exist "${proyecto_produccion}" proyecto_produccion
f_check_var_exist "${proyecto_desarrollo}" proyecto_desarrollo
f_check_var_exist "${proyecto_homologacion}" proyecto_homologacion
#
f_set_ambiente "${ambiente}"

f_check_project_exist ${ambiente}

crear_build_from_file -d "${docker_image}" -a "${app_name}" -s "${strategy}" -n ${ambiente} --directory "${directory}"
