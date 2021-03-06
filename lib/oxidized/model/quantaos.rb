class QuantaOS < Oxidized::Model

  prompt /^\((\w|\S)+\) (>|#)$/
  comment '! '
  
  cmd 'show run' do |cfg|
    cfg.each_line.select do |line|
      not line.match /^!.*$/ and
      not line.match /^\((\w|\S)+\) (>|#)$/ and
      not line.match /^show run$/
    end.join
  end

  cfg :telnet do
    username /^Username:/
    password /^Password:/
  end

  cfg :telnet, :ssh do
    post_login do
      send "enable\n"
      if vars :enable
        cmd vars(:enable)
      else
        cmd ""
      end
    end
    post_login 'terminal length 0'
    pre_logout do
      send "quit\n"
      send "n\n"
    end
  end

end
