main() {
  local GITHUB_EMAIL="pedro.barboza.dev@gmail.com"

  local SSH_KEY_ALGORITHM="ed25519"
  local SSH_KEY_DIRPATH="$(realpath)./.ssh"
  local SSH_KEY_FILENAME="id_$SSH_KEY_ALGORITHM"
  local SSH_KEY_FILEPATH="$SSH_KEY_DIRPATH/$SSH_KEY_FILENAME"
  local SSH_KNOWN_HOSTS_FILEPATH="$SSH_KEY_DIRPATH/known_hosts"

  if [ -d "$SSH_KEY_FILEPATH" ]; then
    echo "The key \"$SSH_KEY_FILEPATH\" already exists, please delete it or change the destination to generate a new one."
    exit 1
  fi

  if [ ! -d "$SSH_KEY_DIRPATH" ]; then
    echo "criando diretório $SSH_KEY_DIRPATH"
    mkdir -p "$SSH_KEY_DIRPATH"
  fi

  # "echo "y\n" | ..." is used to automatically skip the confirmations (yes/no)
  # echo "y\n" | ssh-keygen -t $SSH_KEY_ALGORITHM -C "$GITHUB_EMAIL" -f "$SSH_KEY_FILEPATH" -P "" -N ""

  ssh-keygen -t $SSH_KEY_ALGORITHM -C "$GITHUB_EMAIL" -f "$SSH_KEY_FILEPATH" -P "" -N ""

  touch $SSH_KNOWN_HOSTS_FILEPATH

  ssh-keyscan -t ed25519 github.com >> $SSH_KNOWN_HOSTS_FILEPATH
}

main