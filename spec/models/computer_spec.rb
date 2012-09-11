require 'spec_helper'

describe Computer do
  before(:each) do
    @computer = Computer.create
    @computer.serial_no = 'abc123'
    @computer.asset_tag = 12345
    @computer.cname = 'Comp Example'
    @computer.make = 'Dell'
    @computer.model = 'E6400'
  end
end
