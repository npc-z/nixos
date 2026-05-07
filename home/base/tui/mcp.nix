{pkgs, ...}: {
  home.packages = with pkgs; [
    # MCP server for NixOS
    mcp-nixos
  ];
}
