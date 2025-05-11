{pkgs, ...}: {
  fonts.packages = with pkgs; [
    # symbols icon only
    nerd-fonts.symbols-only
    # Characters
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.dejavu-sans-mono

    julia-mono
    dejavu_fonts

    fira-code
    fira-code-symbols

    # https://github.com/subframe7536/maple-font
    # Maple Mono (Ligature TTF unhinted)
    maple-mono.truetype
    # Maple Mono NF (Ligature unhinted)
    maple-mono.NF-unhinted
    # Maple Mono NF CN (Ligature unhinted)
    maple-mono.NF-CN-unhinted
    # Maple Mono Normal NF (Ligature hinted)
    maple-mono.Normal-NF
    # Maple Mono Normal (Ligature TTF unhinted)
    maple-mono.Normal-TTF
    # Maple Mono Normal NF (No-Ligature hinted)
    maple-mono.NormalNL-NF
    # Maple Mono Normal (No-Ligature TTF unhinted)
    maple-mono.NormalNL-TTF

    # icon fonts
    material-design-icons
    font-awesome

    # Noto 系列字体是 Google 主导的，名字的含义是「没有豆腐」（no tofu），因为缺字时显示的方框或者方框被叫作 tofu
    # Noto 系列字族名只支持英文，命名规则是 Noto + Sans 或 Serif + 文字名称。
    # 其中汉字部分叫 Noto Sans/Serif CJK SC/TC/HK/JP/KR，最后一个词是地区变种。
    noto-fonts # 大部分文字的常见样式，不包含汉字
    noto-fonts-cjk-sans # 汉字部分
    noto-fonts-emoji # 彩色的表情符号字体
    noto-fonts-extra # 提供额外的字重和宽度变种

    # 思源系列字体是 Adobe 主导的。其中汉字部分被称为「思源黑体」和「思源宋体」，是由 Adobe + Google 共同开发的
    source-sans # 无衬线字体，不含汉字。字族名叫 Source Sans 3 和 Source Sans Pro，以及带字重的变体，加上 Source Sans 3 VF
    source-serif # 衬线字体，不含汉字。字族名叫 Source Code Pro，以及带字重的变体
    source-han-sans # 思源黑体
    source-han-serif # 思源宋体
  ];
}
