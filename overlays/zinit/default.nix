(self: super: {
  zinit = super.zinit.overrideAttrs {
    installPhase = ''
      outdir="$out/share/$pname"

      cd "$src"

      # Zplugin's source files
      install -dm0755 "$outdir"
      # Installing backward compatibility layer
      install -m0644 zinit{,-side,-install,-autoload}.zsh "$outdir"
      install -m0755 share/git-process-output.zsh "$outdir"

      # 官方包中没有写入 doc 文件
      # there is a PR:
      # https://github.com/NixOS/nixpkgs/pull/278384

      mkdir -p "$outdir/doc"
      install -m0644 doc/zinit.1 "$outdir/doc/zinit.1"

      # Zplugin autocompletion
      installShellCompletion --zsh _zinit

    '';
  };
})
