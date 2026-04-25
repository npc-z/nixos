{pkgs, ...}: {
  home.packages = with pkgs; [
    # MCP server for NixOS
    # FIXME: can not be built now
    # mcp-nixos
  ];
}
