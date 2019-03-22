#!/bin/bash
f_muestra ()
{
	echo "$(date) : ${@}"
}
f_check_var_exist ()
{
	if [ -z "${1}" ] ; then
		f_muestra "CRITICAL VARIABLE ${2} NO EXISTE"
		f_exit 3 
	fi
}
f_file_existe ()
{
	if ! [ -f "${1}" ] ; then
		f_muestra "CRITICAL FILE ${1} NO EXISTE"
                f_exit 3 
	fi
}
f_cargar_environment () 
{
	f_check_var_exist "${1}"
	f_file_existe "${1}"
	source ${1}
}
f_check_error ()
{
	if [ ${1} -gt 0 ] ; then
		f_muestra "CRITICAL ${2}"
		exit 3
	fi
}
f_exit ()
{
	exit ${1}
}
