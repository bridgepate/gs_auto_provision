CONFIG = {
  :'gxp2130-001' => {
    :macaddress => '000B825E5011',
    :ipaddress => '10.28.1.10',
    :config => 'reception1.rb',
    #    :accounts => {:account1 => '1111,1,Brijesh Patel', :account2 => '1000,2,Mario Becroft'}
    :accounts => {'1' => {:extension => '7930',:lineno => '1',:dn => 'bpatel',:displayname => 'Brijesh Patel'},'2' => {:extension => '7931',:lineno => '2',:displayname => 'IT'}}
    
  # },
  #   :'gxp22130-002' => {
  #   :macaddress => '000B8264BE08',
  #   :ipaddress => '10.28.1.11',
  #   :config => 'base2140conf.rb',
  #   :accounts => {:account1 => '2222,1,IT Office'}
  }
}
