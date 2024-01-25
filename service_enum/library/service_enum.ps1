#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy
#AnsibleRequires -OSVersion 6.2
#AnsibleRequires -CSharpUtil Ansible.Basic

# Example for running playbook: ansible-playbook -i 192.168.60.20, custom_play.yml -e "ansible_user=user ansible_password=password123 ansible_shell_type=powershell ansible_connection=ssh host_key_checking=false"

# Example Playbook
# - name: Use Custom Module
#  hosts: all
#  vars:
#    ansible_shell_type: powershell
#    ansible_shell_executable: powershell.exe
#  tasks:
#    - name: Run custom module
#      service_enum:
#        desired_state: running
#      register: result
#    - name: Print result
#      debug:
#        var: result.msg


$spec = @{
	options = @{
		# desired_state is the argument passed from the playbook
		desired_state = @{
			type = "str"; choices = "running", "stopped"
		}
	}
}


$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)
$desired_state = $module.Params.desired_state

$services = Get-WmiObject -Class Win32_Service | Select-Object DisplayName, State
$result = $services | ConvertTo-CSV
$returnValue = @()

foreach ($item in $result) {
	$itemSplit = $item -split ","
	$serviceName = $itemSplit[0]
	$serviceState = $itemSplit[1]

	# Only add services that have the started state to the return array if provided argument is only for started services
	if ( $desired_state -eq "running" ) {
		# only output services that are running
		if ( $serviceState -like "*Running*" ) {
			$returnValue += $serviceName
		} else {
			continue
		}
	# Only add services that have the stopped state to the return array if provided argument is only for stopped services
	} elseif ( $desired_state -eq "stopped" ) {
		if ( $serviceState -like "*Stopped*" ) {
			$returnValue+= $serviceName
		} else {
			continue
		}
	} else {
		continue
	}
}

$module.Result.msg = $returnValue
$module.Result.changed = $false
$module.ExitJson()
