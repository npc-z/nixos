{pkgs, ...}: {
  home.packages = with pkgs; [
    # MCP server for NixOS
    # FIXME: build failed now
    # mcp-nixos
  ];
}
