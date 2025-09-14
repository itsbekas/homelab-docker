directory=""

set_directory() {
    directory="$1"
}

replace_env_var_in_file() {
    local var_name="$1"
    local target_file="/opt/docker/${directory}/$2"
    local env_file="/opt/docker/${directory}/${3:-.env}"

    local var_value
    var_value=$(grep "^${var_name}=" "$env_file" | cut -d'=' -f2- | sed "s/^'//;s/'$//")

    sed -i "s|${var_name}|${var_value}|g" "$target_file"
}
