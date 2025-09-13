{
  pkgs,
  user,
  ...
}: {
  # User account configuration
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };
}
