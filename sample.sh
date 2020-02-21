#!/bin/sh
#set -x

CMDNAME=$(basename $0)
TMPFILE=/tmp/`basename ${CMDNAME}`.$$


#返却値を設定
RC_OK=0
RC_ERROR=1
RC_CANCEL=2

# ON/OFFフラグをセット
FLG_OFF=0
FLG_ON=1

#デフォルト値をセット
TRGDATE=`date +"%Y-%m-%d"`
TRGCODE=12345
RESTART_FLG=${FLG_OFF}
INIT_FLG=${FLG_OFF}
FORCEMODE=${FLG_OFF}

###############################
# version
###############################
version() {
    echo "${CMDNAME} version 0.0.1 "
}

###############################
# usage
###############################
usage() 
{
cat << EOF

	${CMDNAME} is a tool for ... 

	Usage:
		${CMDNAME} [--reboot ] [--init] [--date <date>] [--code <code>] [--force] [--version] [--help]

	Options:
		--reboot, -r                   system reboot
		--init, -i                     initialize
		--date, -D       <date>        date　(YYYY-MM-DD)
		--code, -C       <code>        code
		--force, -f                    force mode
		--version, -v                  version info
		--help, -h                     usage
		
EOF
}

###############################
# yesno check 
###############################
yesno_chk()
{
  read ANSWER?"OK？(y/n)-->"
  while true;do
    case ${ANSWER} in
      yes | y)
          return ${RC_OK}
          ;;
      *)
          return ${RC_CANCEL}
          ;;
    esac
  done
}

###############################
# get options
###############################
get_options()
{

	# param check
	if [[ $# -eq 0 ]]; then
	  usage
	  return ${RC_ERROR}
	fi

	# get options
	while [ $# -gt 0 ];
	do
		case ${1} in

			--debug|-d)
				set -x
			;;

			--reboot|-r)
				RESTART_FLG=${FLG_ON}
			;;
			
			--init|-i)
				INIT_FLG=${FLG_ON}
			;;
			
			--date|-D)
				TRGDATE=${2}
				shift
			;;
			
			--code|-C)
				TRGCODE=${2}
				shift
			;;
			
			--force|-f)
				FORCEMODE=${FLG_ON}
			;;
			
			--version|-v)
				version
				return ${RC_ERROR}
			;;
			
			--help|-h)
				usage
				return ${RC_ERROR}
			;;

			*)
				echo "[${CMDNAME}][ERROR] Invalid option '${1}'"
				usage
				return ${RC_ERROR}
			;;
		esac
		shift
	done

}

###############################
# func1
###############################
sys_reboot()
{

	echo "[${CMDNAME}] SYSTEM REBOOT START"
	
	echo "DATE = ${TRGDATE}"
	echo "CODE = ${TRGCODE}"
	
	echo "[${CMDNAME}] SYSTEM REBOOT END"
	
	return ${RC_OK}
}

###############################
# func2
###############################
sys_initialize()
{

	echo "[${CMDNAME}] INIT START"
	
	echo "DATE = ${TRGDATE}"
	echo "CODE = ${TRGCODE}"
	
	echo "[${CMDNAME}] INIT END"
	
	return ${RC_OK}
}
###############################
#
# main
#
###############################

###############################
# Call get_options
###############################
get_options $@
if [ $? -ne ${RC_OK} ]; then
	exit ${RC_ERROR}
fi

###############################
# 
###############################
if [[ ${RESTART_FLG} -eq ${FLG_ON} ]]
then
	sys_reboot
	if [[ $? -ne ${RC_OK} ]]
	then
		echo "[${CMDNAME}][ERROR] error occurred : sys_reboot"
		exit ${RC_ERROR}
	fi
fi

###############################
# 
###############################
if [[ ${INIT_FLG} -eq ${FLG_ON} ]]
then
	sys_initialize
	if [[ $? -ne ${RC_OK} ]]
	then
		echo "[${CMDNAME}][ERROR] error occurred : sys_initialize"
		exit ${RC_ERROR}
	fi
fi

echo "[${CMDNAME}] command complete"
echo ""

exit ${RC_OK}
