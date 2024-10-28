{...}: {
  networking = {
    extraHosts = ''
      119.23.218.175	jump
      10.0.2.9	prodjump
      # 灰度
      # 119.28.183.60 www.ksher.cn

      # dev env
      120.76.159.195 dev2-merchant.kgp.ksher.cn
      120.76.159.195 dev2-om.kgp.ksher.cn
    '';
  };
}
