{...}: {
  networking = {
    networkmanager.enable = true;
    extraHosts = ''
      # 140.82.113.4	github.com
      # 185.199.108.133 raw.githubusercontent.com
      # 185.199.109.133 raw.githubusercontent.com
      # 185.199.110.133 raw.githubusercontent.com
      # 185.199.111.133 raw.githubusercontent.com
      # 20.201.28.151 github.com
      # 20.205.243.166 github.com
      # 20.87.245.0 github.com
      # 20.248.137.48 github.com
      # 20.207.73.82 github.com
      # 20.27.177.113 github.com
      # 20.200.245.247 github.com
      # 20.175.192.147 github.com
      # 20.233.83.145 github.com
      # 20.29.134.23 github.com
      # 20.201.28.152 github.com
      # 20.205.243.160 github.com
      # 20.87.245.4 github.com
      # 20.248.137.50 github.com
      # 20.207.73.83 github.com
      # 20.27.177.118 github.com
      # 20.200.245.248 github.com
      # 20.175.192.146 github.com
      # 20.233.83.149 github.com
      # 20.29.134.19 github.com
      119.23.218.175	jump
      10.0.2.9	prodjump
    '';
  };
}
