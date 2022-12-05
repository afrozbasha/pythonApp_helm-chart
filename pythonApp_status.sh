status=$(helm status backend | grep "STATUS")

case "$status" in
	#case 1
	"STATUS: deployed") helm status backend | grep "STATUS" ;;
	#case 2
	"STATUS: pending" | "STATUS: unknown" | "STATUS: uninstalled" | "STATUS: superseded" | "STATUS: failed" | "STATUS: uninstalling" | "STATUS: pending-install" | "STATUS: pending-upgrade" | "STATUS: pending-rollback") helm rollback backend ;;
esac
